class Admins::NewsItemsController < AdminsController

  # GET /admin/news_items
  def index
    @news_items = NewsItem.paginate(order: 'updated_at desc', page: params[:page], per_page: 25, include: { translations: :language })
    set_news_items_options
  end

  # GET /admin/news_items/new
  def new
    @news_item = NewsItem.new(active: true)
    @translated_news_item = @news_item.translations.build(language_id: current_language.id, active_translation: true)
    set_news_item_new_options
  end

  # POST /admin/news_items
  def create
    @news_item = NewsItem.new(params[:news_item])
    @translated_news_item = @news_item.translations.build(params[:translated_news_item])
    @news_item.last_update_user_id = current_user.id unless @news_item.blank?
    expire_fragment(action: 'index', action_suffix: "news_#{@translated_news_item.language.iso_639_1}")
    if @news_item.save
      @news_item.update_attributes(origin_id: @news_item.id, site_id: PEER_SITE_ID)
      sync_create_news_item
      flash[:notice] = I18n.t(:admin_news_item_create_successful_notice,
                              page_name: @news_item.page_name,
                              anchor: @news_item.page_name.gsub(' ', '_').downcase)
      redirect_to admin_news_items_path(anchor: @news_item.page_name.gsub(' ', '_').downcase)
    else
      flash.now[:error] = I18n.t(:admin_news_item_create_unsuccessful_error)
      set_news_item_new_options
      render :new
    end
  end

  # GET /admin/news_items/:id/edit
  def edit
    @news_item = NewsItem.find(params[:id])
    set_news_item_edit_options
  end

  # PUT /admin/news_items/:id
  def update
    @news_item = NewsItem.find(params[:id])
    if @news_item.update_attributes(params[:news_item])
      sync_update_news_item
      flash[:notice] = I18n.t(:admin_news_item_update_successful_notice,
                              page_name: @news_item.page_name,
                              anchor: @news_item.page_name.gsub(' ', '_').downcase)
      @news_item.translations.each do |translated_news_item|
        expire_fragment(action: 'index', action_suffix: "news_#{translated_news_item.language.iso_639_1}")
      end
      redirect_to admin_news_items_path(anchor: @news_item.page_name.gsub(' ', '_').downcase)
    else
      flash.now[:error] = I18n.t(:admin_news_item_update_unsuccessful_error)
      set_news_item_edit_options
      render :edit
    end
  end

  # DELETE /admin/news_items/:id
  def destroy
    return redirect_to action: 'index', status: :moved_permanently unless request.delete?
    news_item = NewsItem.find(params[:id], include: [:translations])
    page_name = news_item.page_name
    news_item.last_update_user_id = current_user.id
    temp_news_item = NewsItem.new(news_item.attributes)
    news_item.destroy
    sync_delete_news_item(temp_news_item)
    flash[:notice] = I18n.t(:admin_news_item_delete_successful_notice, page_name: page_name)
    redirect_to action: 'index', status: :moved_permanently
  end

private

  def set_news_items_options
    @page_title = I18n.t(:admin_news_items_page_title)
  end

  def set_news_item_new_options
    set_news_items_options
    set_translated_news_item_new_options
    @page_subheader = I18n.t(:admin_news_item_new_header)
  end

  def set_translated_news_item_new_options
    @languages = @news_item.not_available_in_languages(nil)
  end

  def set_news_item_edit_options
    set_news_items_options
    @page_subheader = I18n.t(:admin_news_item_edit_header, page_name: @news_item.page_name)
  end
  
  def sync_create_news_item
    sync_params = { language: params[:translated_news_item][:language_id] }.
      merge(params[:news_item]).reverse_merge(params[:translated_news_item])
    options = { user: current_user, object: @news_item, action_id: SyncObjectAction.create.id,
                type_id: SyncObjectType.news_item.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_news_item
   sync_params = params[:news_item]
   options = { user: current_user, object: @news_item, action_id: SyncObjectAction.update.id,
               type_id: SyncObjectType.news_item.id, params: sync_params }
   SyncPeerLog.log_action(options)
  end
  
  def sync_delete_news_item(temp_news_item)
    options = { user: current_user, object: temp_news_item, action_id: SyncObjectAction.delete.id,
                type_id: SyncObjectType.news_item.id, params: {} }
    SyncPeerLog.log_action(options)
  end
end
