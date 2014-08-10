class ForumsController < ApplicationController

  layout 'forum'
  before_filter :must_be_allowed_to_view_forum
  before_filter :allow_login_then_submit, only: [ :create ]
  before_filter :restrict_to_admins, only: [ :create, :destroy, :move_up, :move_down ]

  # GET /forums
  def index
    @forum_categories = ForumCategory.order(:view_order).includes(forums: :last_post)
    ForumCategory.preload_associations(@forum_categories, { forums: { last_post: [ :user, { forum_topic: :forum } ] } })
  end

  # GET /forums/:id
  def show
    params[:page] ||= 1
    params[:page] = 1 if params[:page].to_i < 1
    @forum = Forum.find(params[:id])
    @forum_topics = @forum.forum_topics.visible.order('last_post_id desc').paginate(page: params[:page], per_page: Forum::TOPICS_PER_PAGE)
    ForumTopic.preload_associations(@forum_topics, { last_post: [ :user, { forum_topic: :forum } ] })
  end

  # GET /forums/new
  def new
  end

  # POST /forums
  def create
    forum_data = params[:forum]
    if session[:submitted_data]
      forum_data ||= session[:submitted_data][:forum]
      session.delete(:submitted_data)
    end
    @forum = Forum.new(forum_data)
    @forum.user_id = current_user.id
    if @forum.save
      @forum.update_attributes(site_id: PEER_SITE_ID, origin_id: @forum.id)
      sync_create_forum
      flash[:notice] = I18n.t('forums.create_successful')
    else
      flash[:error] = I18n.t('forums.create_failed')
      render :new
      return
    end
    redirect_to forums_path
  end

  # GET /forums/:id/edit
  def edit
    @forum = Forum.find(params[:id])
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to Forum with ID=#{@forum.id}" unless current_user.can_update?(@forum)
  end

  # PUT /forums/:id
  def update
    @forum = Forum.find(params[:id])
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to Forum with ID=#{@forum.id}" unless current_user.can_update?(@forum)
    if @forum.update_attributes(params[:forum])
      sync_update_forum
      flash[:notice] = I18n.t('forums.update_successful')
    else
      flash[:error] = I18n.t('forums.update_failed')
      render :edit
      return
    end
    redirect_to forums_path
  end

  # DELETE /forums/:id
  def destroy
    @forum = Forum.find(params[:id])
    if @forum.open_topics.count == 0
      @copied_forum = @forum.dup
      @forum.destroy
      sync_destroy_forum
      flash[:notice] = I18n.t('forums.delete_successful')
    else
      flash[:error] = I18n.t('forums.delete_failed_not_empty')
    end
    redirect_to forums_path
  end

  # POST /forums/:id/move_up
  def move_up
    @forum = Forum.find(params[:id])
    if @next_lowest = Forum.where("forum_category_id = #{@forum.forum_category_id} AND view_order < #{@forum.view_order}").order("view_order desc").limit(1).first
      new_view_order = @next_lowest.view_order
      @next_lowest.update_attributes(view_order: @forum.view_order)
      @next_lowest.update_column(:swap_updated_at, @next_lowest.updated_at)
      tmp = @forum.view_order
      @forum.update_attributes(view_order: new_view_order)
      @forum.update_column(:swap_updated_at, @forum.updated_at)
      sync_swap_order(@next_lowest, tmp)
      sync_swap_order(@forum, new_view_order)
      flash[:notice] = I18n.t('forums.move_successful')
    else
      flash[:error] = I18n.t('forums.move_failed')
    end
    redirect_to forums_path
  end

  # POST /forums/:id/move_down
  def move_down
    @forum = Forum.find(params[:id])
    if @next_highest = Forum.where("forum_category_id = #{@forum.forum_category_id} AND view_order > #{@forum.view_order}").order("view_order asc").limit(1).first
      new_view_order = @next_highest.view_order
      @next_highest.update_attributes(view_order: @forum.view_order)
      @next_highest.update_column(:swap_updated_at, @next_highest.updated_at)
      tmp = @forum.view_order
      @forum.update_attributes(view_order: new_view_order)
      @forum.update_column(:swap_updated_at, @forum.updated_at)
      sync_swap_order(@next_highest, tmp)
      sync_swap_order(@forum, new_view_order)
      flash[:notice] = I18n.t('forums.move_successful')
    else
      flash[:error] = I18n.t('forums.move_failed')
    end
    redirect_to forums_path
  end

  private

  def must_be_allowed_to_view_forum
    return if Rails.env.test?
    if current_user.blank?
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
      raise EOL::Exceptions::SecurityViolation,
        "Must be logged in and sufficient priveleges to access to Forum"
    end
  end
  
  # synchronization
  def sync_create_forum
    forum_category = ForumCategory.find(params[:forum][:forum_category_id])
    if forum_category
      forum_category_origin_id = forum_category.origin_id
      forum_category_site_id = forum_category.site_id
    else
      forum_category_origin_id = nil
      forum_category_site_id = nil
    end
    sync_params = { forum_category_origin_id: forum_category_origin_id,
                    forum_category_site_id: forum_category_site_id }.reverse_merge(params[:forum])
    options = { user: current_user, object: @forum, action_id: SyncObjectAction.create.id,
                type_id: SyncObjectType.forum.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_forum
    forum_category = ForumCategory.find(params[:forum][:forum_category_id])
    if forum_category
      forum_category_origin_id = forum_category.origin_id
      forum_category_site_id = forum_category.site_id
    else
      forum_category_origin_id = nil
      forum_category_site_id = nil
    end
    sync_params = { forum_category_origin_id: forum_category_origin_id,
                    forum_category_site_id: forum_category_site_id,
                    updated_at: @forum.updated_at }.reverse_merge(params[:forum])
    options = { user: current_user, object: @forum, action_id: SyncObjectAction.update.id,
                type_id: SyncObjectType.forum.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_destroy_forum
    options = { user: current_user, object: @copied_forum, action_id: SyncObjectAction.delete.id,
                type_id: SyncObjectType.forum.id, params: {} }
    SyncPeerLog.log_action(options)
  end
  
  def sync_swap_order(forum, forum_order)
    sync_params = { forum_sort_order: forum_order,
                    updated_at: forum.swap_updated_at }
    options = { user: current_user, object: forum, action_id: SyncObjectAction.swap.id,
               type_id: SyncObjectType.forum.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
end
