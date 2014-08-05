class ContentPartners::ContentPartnerContactsController < ContentPartnersController

  # TODO - there's a lot of duplication here that could be fixed with before_filters and the like.

  before_filter :check_authentication

  layout 'partners'

  # GET /content_partners/:content_partner_id/contacts/new
  def new
    @partner = ContentPartner.find(params[:content_partner_id])
    @contact = @partner.content_partner_contacts.build
    access_denied && return unless current_user.can_create?(@contact)
    set_new_contact_options
  end

  # POST /content_partners/:content_partner_id/contacts
  def create
    @partner = ContentPartner.find(params[:content_partner_id])
    @contact = @partner.content_partner_contacts.build(params[:content_partner_contact])
    access_denied && return unless current_user.can_create?(@contact)
    if @contact.save
      @contact.update_attributes(origin_id: @contact.id, site_id: PEER_SITE_ID)
      sync_create_contact
      flash[:notice] = I18n.t(:content_partner_contact_create_successful_notice)
      redirect_to content_partner_resources_path(@partner), status: :moved_permanently
    else
      set_new_contact_options
      flash.now[:error] = I18n.t(:content_partner_contact_create_unsuccessful_error)
      render :new
    end
  end

  # GET /content_partners/:content_partner_id/contacts/:id/edit
  def edit
    @partner = ContentPartner.find(params[:content_partner_id])
    @contact = @partner.content_partner_contacts.find(params[:id])
    access_denied && return unless current_user.can_update?(@contact)
    set_edit_contact_options
  end

  # PUT /content_partners/:content_partner_id/contacts/:id
  def update
    @partner = ContentPartner.find(params[:content_partner_id])
    @contact = @partner.content_partner_contacts.find(params[:id])
    access_denied && return unless current_user.can_update?(@contact)
    if @contact.update_attributes(params[:content_partner_contact])
      sync_update_contact
      flash[:notice] = I18n.t(:content_partner_contact_update_successful_notice)
      redirect_to content_partner_resources_path(@partner), status: :moved_permanently
    else
      flash.now[:error] = I18n.t(:content_partner_contact_update_unsuccessful_error)
      render :edit
    end
  end

  # DELETE /content_partners/:content_partner_id/contacts/:id
  def delete
    @partner = ContentPartner.find(params[:content_partner_id])
    @contact = @partner.content_partner_contacts.find(params[:id])
    access_denied && return unless current_user.can_delete?(@contact)
    if @partner.content_partner_contacts.delete(@contact)
      sync_delete_contact
      flash[:notice] = I18n.t(:content_partner_contact_delete_successful_notice)
      redirect_to content_partner_resources_path(@partner), status: :moved_permanently
    else
      flash[:notice] = I18n.t(:content_partner_contact_delete_unsuccessful_error)
      redirect_to edit_content_partner_contact_path(@partner, @contact), status: :moved_permanently
    end
  end

private

  def set_contact_options
    @contact_roles = ContactRole.all
    @mail_intervals = [[I18n.t(:never), 0] , [I18n.t(:daily), 1*24], [I18n.t(:weekly), 7*24], [I18n.t(:monthly), 30*24]]
  end

  def set_new_contact_options
    set_contact_options
    @page_subheader = I18n.t(:content_partner_contact_new_page_subheader)
  end

  def set_edit_contact_options
    set_contact_options
    @page_subheader = I18n.t(:content_partner_contact_edit_page_subheader)
  end
  
  def sync_create_contact
    sync_params = { partner_origin_id: @partner.origin_id,
                    partner_site_id: @partner.site_id }.merge(params[:content_partner_contact])
    options = { user: current_user, object: @contact, action_id: SyncObjectAction.create.id,
                type_id: SyncObjectType.contact.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_contact
    sync_params = params[:content_partner_contact]
    options = { user: current_user, object: @contact, action_id: SyncObjectAction.update.id,
                type_id: SyncObjectType.contact.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
  
  def sync_delete_contact
    sync_params = { partner_origin_id: @partner.origin_id,
                    partner_site_id: @partner.site_id }
    options = { user: current_user, object: @contact, action_id: SyncObjectAction.delete.id,
                type_id: SyncObjectType.contact.id, params: sync_params }
    SyncPeerLog.log_action(options)
  end
end
