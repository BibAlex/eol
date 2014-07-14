class Admins::ContentPagesController < AdminsController

  skip_before_filter :restrict_to_admins
  before_filter :restrict_to_admins_and_cms_editors

  # GET /admin/content_pages
  def index
    @content_pages = ContentPage.find_top_level
    set_content_pages_options
  end

  # GET /admin/content_pages/new
  # GET /admin/content_pages/:content_page_id/children/new
  def new
    parent_content_page = ContentPage.find(params[:content_page_id]) if params[:content_page_id]
    @content_page = ContentPage.new(parent: parent_content_page, active: true)
    @translated_content_page = @content_page.translations.build(language_id: current_language.id, active_translation: true)
    set_content_page_new_options
  end

  # POST /admin/content_pages
  def create
    sort_order = ContentPage.initial_sort_order(params[:content_page][:parent_content_page_id])
    params[:content_page][:sort_order] = sort_order + 1
    @content_page = ContentPage.new(params[:content_page])
    @translated_content_page = @content_page.translations.build(params[:translated_content_page])
    @content_page.last_update_user_id = current_user.id unless @content_page.blank?
    
    if @content_page.save
      @content_page.update_column(:origin_id, @content_page.id)
      @content_page.update_column(:site_id, PEER_SITE_ID)
      sync_create_content_page
      flash[:notice] = I18n.t(:admin_content_page_create_successful_notice,
                              page_name: @content_page.page_name,
                              anchor: @content_page.page_name.gsub(' ', '_').downcase)
      redirect_to admin_content_pages_path(anchor: @content_page.page_name.gsub(' ', '_').downcase)
    else
      flash.now[:error] = I18n.t(:admin_content_page_create_unsuccessful_error)
      set_content_page_new_options
      render :new
    end
  end

  # GET /admin/content_pages/:id/edit
  def edit
    @content_page = ContentPage.find(params[:id])
    set_content_page_edit_options
  end

  # PUT /admin/content_pages/:id
  def update
    @content_page = ContentPage.find(params[:id])
    if @content_page.update_attributes(params[:content_page])
      sync_update_content_page
      flash[:notice] = I18n.t(:admin_content_page_update_successful_notice,
                              page_name: @content_page.page_name,
                              anchor: @content_page.page_name.gsub(' ', '_').downcase)
      redirect_to admin_content_pages_path(anchor: @content_page.page_name.gsub(' ', '_').downcase)
    else
      flash.now[:error] = I18n.t(:admin_content_page_update_unsuccessful_error)
      set_content_page_edit_options
      render :edit
    end
  end

  # DELETE /admin/content_pages/:id
  def destroy
    return redirect_to action: 'index', status: :moved_permanently unless request.delete?
    content_page = ContentPage.find(params[:id], include: [:translations, :children])
    page_name = content_page.page_name
    content_page.last_update_user_id = current_user.id
    parent_content_page_id = content_page.parent_content_page_id
    sort_order = content_page.sort_order
    content_page.destroy
    ContentPage.update_sort_order_based_on_deleting_page(parent_content_page_id, sort_order)
    sync_destroy_content_page(content_page)
    flash[:notice] = I18n.t(:admin_content_page_delete_successful_notice, page_name: page_name)
    redirect_to action: 'index', status: :moved_permanently
  end

  # POST /admin/content_pages/:id/move_up
  def move_up
    content_page = ContentPage.find_by_id(params[:id])
    sort_order = content_page.sort_order
    new_sort_order = sort_order - 1
    # TODO: This assumes distance between sort order is 1, change it to be less than greater than next one
    if swap_page = ContentPage.find_by_parent_content_page_id_and_sort_order(content_page.parent_content_page_id, new_sort_order)
      swap_page.update_column(:sort_order, sort_order)
    end
    content_page.update_column(:sort_order, new_sort_order)
    sync_swap_order(content_page, swap_page, new_sort_order, sort_order)
    flash[:notice] = I18n.t(:admin_content_page_sort_order_updated)
    redirect_to action: :index, status: :moved_permanently
  end

  # POST /admin/content_pages/:id/move_down
  def move_down
    content_page = ContentPage.find_by_id(params[:id])
    sort_order = content_page.sort_order
    new_sort_order = sort_order + 1
    # TODO: This assumes distance between sort order is 1, change it to be less than greater than next one
    if swap_page = ContentPage.find_by_parent_content_page_id_and_sort_order(content_page.parent_content_page_id, new_sort_order)
     swap_page.update_column(:sort_order, sort_order)
    end
    content_page.update_column(:sort_order, new_sort_order)
    sync_swap_order(content_page, swap_page, new_sort_order, sort_order)
    flash[:notice] = I18n.t(:admin_content_page_sort_order_updated)
    redirect_to action: :index, status: :moved_permanently
  end

private

  def set_content_pages_options
    @page_title = I18n.t(:admin_content_pages_page_title)
  end

  def set_content_page_new_options
    set_content_pages_options
    set_translated_content_page_new_options
    @page_subheader = I18n.t(:admin_content_page_new_header)
    @parent_content_pages = ContentPage.unscoped.all( select: 'id, page_name' ).delete_if{ |p| p == @content_page }.compact
  end

  def set_translated_content_page_new_options
    @languages = @content_page.not_available_in_languages(nil)
  end

  def set_content_page_edit_options
    set_content_pages_options
    @page_subheader = I18n.t(:admin_content_page_edit_header, page_name: @content_page.page_name)
    @parent_content_pages = ContentPage.unscoped.all( select: 'id, page_name' ).delete_if{ |p| p == @content_page }.compact
    @navigation_tree = ContentPage.get_navigation_tree(@content_page.parent_content_page_id)
  end
  
  # synchronization
  def sync_create_content_page
    parent_content_page = ContentPage.find(params[:content_page][:parent_content_page_id])
    sync_params = {language: params[:translated_content_page][:language_id],
                   parent_content_page_origin_id: parent_content_page.origin_id,
                   parent_content_page_site_id: parent_content_page.site_id}.reverse_merge(params[:content_page], params[:translated_content_page])
    sync_params = SyncPeerLog.delete_keys([:language_id, :parent_content_page_id],sync_params)
    #sync_params.delete("language_id")
    options = { user: current_user, object: @content_page, action_id: SyncObjectAction.create.id,
               type_id: SyncObjectType.content_page.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_content_page
    options = { user: current_user, object: @content_page, action_id: SyncObjectAction.update.id,
               type_id: SyncObjectType.content_page.id, params: params[:content_page] }
    SyncPeerLog.log_action(options)
  end
  
  def sync_destroy_content_page(content_page)
    options = { user: current_user, object: content_page, action_id: SyncObjectAction.delete.id,
               type_id: SyncObjectType.content_page.id, params: {} }
    SyncPeerLog.log_action(options)
  end
  
  def sync_swap_order(content_page, swap_page, content_page_order, swap_page_order)
    sync_params = { swap_page_origin_id: swap_page.origin_id,
                   swap_page_site_id: swap_page.site_id,
                   swap_page_sort_order: swap_page_order,
                   content_page_sort_order: content_page_order }
    options = { user: current_user, object: content_page, action_id: SyncObjectAction.swap.id,
               type_id: SyncObjectType.content_page.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
end
