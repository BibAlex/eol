class Forums::CategoriesController < ForumsController

  layout 'forum'
  before_filter :restrict_to_admins
  before_filter :allow_login_then_submit, only: [:create]

  # GET /forum_categories/new
  def new
  end

  # POST /forum_categories
  def create
    @category = ForumCategory.new(params[:forum_category])
    @category.user_id = current_user.id

    if @category.save
      @category.update_attributes(origin_id: @category.id, site_id: PEER_SITE_ID)
      sync_create_or_update_category("create")
      flash[:notice] = I18n.t('forums.categories.create_successful')
    else
      flash[:error] = I18n.t('forums.categories.create_failed')
      render :new
      return
    end
    redirect_to forums_path
  end

  # GET /forum_categories/:id/edit
  def edit
    @category = ForumCategory.find(params[:id])
    # TODO - second argument to constructor should be an I18n key for a human-readable error.
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to ForumCategory with ID=#{@category.id}" unless current_user.can_update?(@category)
  end

  # PUT /forum_categories/:id
  def update
    @category = ForumCategory.find(params[:id])
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to ForumCategory with ID=#{@category.id}" unless current_user.can_update?(@category)
    if @category.update_attributes(params[:forum_category])
      sync_create_or_update_category("update")
      flash[:notice] = I18n.t('forums.categories.update_successful')
    else
      flash[:error] = I18n.t('forums.categories.update_failed')
      render :edit
      return
    end
    redirect_to forums_path
  end

  # DELETE /forum_categories/:id
  def destroy
    @category = ForumCategory.find(params[:id])
    raise EOL::Exceptions::SecurityViolation,
      "User with ID=#{current_user.id} does not have edit access to ForumCategory with ID=#{@category.id}" unless current_user.can_delete?(@category)
    if @category.forums.count == 0
      @category.destroy
      sync_destroy_category
      flash[:notice] = I18n.t('forums.categories.delete_successful')
    else
      flash[:error] = I18n.t('forums.categories.delete_failed_not_empty')
    end
    redirect_to forums_path
  end

  # POST /forum_categories/:id/move_up
  def move_up
    @category = ForumCategory.find(params[:id])
    if @next_lowest = ForumCategory.where("view_order < #{@category.view_order}").order("view_order desc").limit(1).first
      new_view_order = @next_lowest.view_order
      @next_lowest.update_attributes(view_order: @category.view_order)
      @category.update_attributes(view_order: new_view_order)
      flash[:notice] = I18n.t('forums.categories.move_successful')
    else
      flash[:error] = I18n.t('forums.categories.move_failed')
    end
    redirect_to forums_path
  end

  # POST /forum_categories/:id/move_down
  def move_down
    @category = ForumCategory.find(params[:id])
    if @next_highest = ForumCategory.where("view_order > #{@category.view_order}").order("view_order asc").limit(1).first
      new_view_order = @next_highest.view_order
      @next_highest.update_attributes(view_order: @category.view_order)
      @category.update_attributes(view_order: new_view_order)
      flash[:notice] = I18n.t('forums.categories.move_successful')
    else
      flash[:error] = I18n.t('forums.categories.move_failed')
    end
    redirect_to forums_path
  end
  
  private
  # synchronization
  def sync_destroy_category
    options = { user: current_user, object: @category, action_id: SyncObjectAction.delete.id,
                type_id: SyncObjectType.category.id, params: {} }
    SyncPeerLog.log_action(options)
  end

  private 
    def sync_create_or_update_category(action)
      if action == "create"      
        action_id = SyncObjectAction.create.id
      else 
        action_id = SyncObjectAction.update.id 
      end
      sync_params = params[:forum_category]
      options = { user: current_user, object: @category, action_id: action_id,
                  type_id: SyncObjectType.category.id, params: sync_params }
      SyncPeerLog.log_action(options)
    end
    
end
