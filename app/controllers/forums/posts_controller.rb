class Forums::PostsController < ForumsController

  skip_before_filter :restrict_to_admins
  before_filter :allow_login_then_submit, only: [ :create ]
  before_filter :check_authentication, except: [ :show, :new, :reply ]

  # GET /forums/:forum_id/topics/:topic_id/posts/:id
  def show
    post = ForumPost.find(params[:id])
    page = post.page_in_topic
    @topic = post.forum_topic
    @topic.increment_view_count
    @posts = @topic.forum_posts.paginate(page: page, per_page: ForumTopic::POSTS_PER_PAGE)
    ForumPost.preload_associations(@posts, [ :user, :forum_topic ])
    render template: 'forums/topics/show'
  end

  # GET /forums/:forum_id/topics/:topic_id/posts/new
  def new
    @reply_to_post = ForumPost.find(params[:reply_to]) rescue nil
    @topic = @reply_to_post.forum_topic
  end

  # POST /forums/:forum_id/topics/:topic_id/posts
  def create
    topic_id = params[:topic_id]
    post_data = params[:forum_post]
    if session[:submitted_data]
      post_data ||= session[:submitted_data][:forum_post]
      topic_id ||= session[:submitted_data][:topic_id]
      session.delete(:submitted_data)
    end
    @topic = ForumTopic.find(topic_id)
    @post = ForumPost.new(post_data)
    @post.user_id = current_user.id
    if @post.save
      @post.update_attributes(origin_id: @post.id, site_id: PEER_SITE_ID)
      sync_create_post
      flash[:notice] = I18n.t('forums.posts.create_successful')
    else
      flash[:error] = I18n.t('forums.posts.create_failed')
      flash[:error] << " #{@post.errors.full_messages.join('; ')}." if @post.errors.any?
      redirect_to params[:return_to] || forum_topic_path(@topic.forum, @topic)
      return
    end
    redirect_to forum_topic_post_path(@topic.forum, @topic, @post.id)
  end

  # GET /forums/:forum_id/topics/:topic_id/posts/:id/reply
  def reply
    @reply_to_post = ForumPost.find(params[:id]) rescue nil
    @topic = @reply_to_post.forum_topic
    render :new
  end

  # GET /forums/:forum_id/topics/:topic_id/posts/:id/edit
  def edit
    @post = ForumPost.find(params[:id])
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to ForumPost with ID=#{@post.id}" unless current_user.can_update?(@post)
  end

  # PUT /forums/:forum_id/topics/:topic_id/posts/:id
  def update
    @post = ForumPost.find(params[:id])
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to ForumPost with ID=#{@post.id}" unless current_user.can_update?(@post)
    if @post.update_attributes(params[:forum_post])
      sync_update_post
      flash[:notice] = I18n.t('forums.posts.update_successful')
    else
      flash[:error] = I18n.t('forums.posts.update_failed')
      flash[:error] << " #{@post.errors.full_messages.join('; ')}." if @post.errors.any?
      render :edit
      return
    end
    redirect_to forum_topic_post_path(@post.forum_topic.forum, @post.forum_topic, @post.id)
  end

  # DELETE /forums/:forum_id/topics/:topic_id/posts/:id
  def destroy
    @post = ForumPost.find(params[:id])
    topic = @post.forum_topic
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to ForumPost with ID=#{@post.id}" unless current_user.can_delete?(@post)
    if @post.topic_starter? && @post.forum_topic.forum_posts.visible.count > 1
      flash[:error] = I18n.t('forums.posts.delete_failed_topic_not_empty')
      redirect_to forum_topic_path(@post.forum_topic.forum, @post.forum_topic)
      return
    else
      if @post.forum_topic.forum_posts.visible.count == 1
        @post.forum_topic.update_attributes({ deleted_at: Time.now, deleted_by_user_id: current_user.id })
        @post.update_attributes({ deleted_at: Time.now, deleted_by_user_id: current_user.id })
        sync_delete_post(@post.forum_topic.deleted_at)
        flash[:notice] = I18n.t('forums.posts.topic_and_post_delete_successful')
        redirect_to forum_path(@post.forum_topic.forum)
        return
      else
        @post.update_attributes({ deleted_at: Time.now, deleted_by_user_id: current_user.id })
        sync_delete_post
        flash[:notice] = I18n.t('forums.posts.delete_successful')
      end
    end
    redirect_to forum_topic_path(@post.forum_topic.forum, @post.forum_topic, page: @post.page_in_topic, anchor: "post_#{@post.id}")
  end
  
  private
  
  # synchronization
  def sync_create_post
    sync_params = { topic_origin_id: @topic.origin_id,
                    topic_site_id: @topic.site_id,
                    edit_count: @post.edit_count }.reverse_merge(params[:forum_post])
    parent_post = ForumPost.find(params[:forum_post][:reply_to_post_id].to_i)  unless params[:forum_post][:reply_to_post_id].blank?
    if parent_post
      sync_params.delete("reply_to_post_id")
      sync_params = sync_params.reverse_merge(parent_post_origin_id: parent_post.origin_id,
                                              parent_post_site_id: parent_post.site_id)
    end
    options = { user: current_user, object: @post, action_id: SyncObjectAction.create.id,
                type_id: SyncObjectType.post.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_post
    sync_params = { edit_count: @post.edit_count, 
                    updated_at: @post.updated_at }.reverse_merge(params[:forum_post])
    options = { user: current_user, object: @post, action_id: SyncObjectAction.update.id,
                type_id: SyncObjectType.post.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_delete_post(topic_deleted_at = nil)
    sync_params = { post_deleted_at: @post.deleted_at,
                    edit_count: @post.edit_count }
    if topic_deleted_at
      sync_params = sync_params.reverse_merge({ topic_deleted_at: topic_deleted_at, topic_origin_id: @post.forum_topic.origin_id,
                                  topic_site_id: @post.forum_topic.site_id })
    end
    options = { user: current_user, object: @post, action_id: SyncObjectAction.delete.id,
                type_id: SyncObjectType.post.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end

end
