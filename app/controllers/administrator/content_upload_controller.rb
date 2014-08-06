require "#{Rails.root}/app/helpers/file_helper"
include FileHelper::ClassMethods

class Administrator::ContentUploadController < AdminController

  layout 'deprecated/left_menu'

  before_filter :set_layout_variables

  before_filter :restrict_to_admins

  def index
    @page_title = I18n.t("uploaded_content")
    @content_uploads = ContentUpload.paginate(order: 'created_at desc', page: params[:page])
  end

  def edit
    @page_title = I18n.t("edit_upload")
    @content_upload = ContentUpload.find(params[:id])
  end

  def update
    @content_upload = ContentUpload.find(params[:id])
    if @content_upload.update_attributes(params[:content_upload])
      sync_update_content_upload
      flash[:notice] = I18n.t(:the_content_was_updated)
      redirect_to(action: 'index', status: :moved_permanently)
    else
      render action: 'edit'
    end
  end

  def new
    @page_title = I18n.t("new_upload")
    @content_upload = ContentUpload.new
  end

  def create
    @content_upload = ContentUpload.create(params[:content_upload])
    if @content_upload.save
      @content_upload.update_attributes(user_id: current_user.id, attachment_extension: File.extname(@content_upload.attachment_file_name))
      upload_file(@content_upload)
      @content_upload.update_attributes(site_id: PEER_SITE_ID, origin_id: @content_upload.id)
      sync_create_content_upload
      flash[:notice] = I18n.t(:the_file_was_uploaded)
      redirect_to(action: 'index', status: :moved_permanently)
    else
      render action: 'new'
    end
  end

private

  def set_layout_variables
    @page_title = $ADMIN_CONSOLE_TITLE
    @navigation_partial = '/admin/navigation'
  end
  
  def sync_create_content_upload
    sync_params = { description: params[:content_upload][:description],
                    link_name: params[:content_upload][:link_name],
                    logo_cache_url: @content_upload.attachment_cache_url,
                    logo_file_name: @content_upload.attachment_file_name,
                    logo_content_type: @content_upload.attachment_content_type,
                    logo_file_size: @content_upload.attachment_file_size,
                    base_url: "#{$CONTENT_SERVER}content/" }
    options = { user: current_user, object: @content_upload, action_id: SyncObjectAction.create.id,
               type_id: SyncObjectType.content_upload.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_content_upload
    sync_params = { description: params[:content_upload][:description],
                    link_name: params[:content_upload][:link_name] }
    options = { user: current_user, object: @content_upload, action_id: SyncObjectAction.update.id,
               type_id: SyncObjectType.content_upload.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end

end
