class KnownUriRelationshipsController < ApplicationController

  before_filter :restrict_to_admins

  # POST /known_uri_relationships
  def create
    if params[:known_uri_relationship][:to_known_uri_id].blank? && params[:autocomlete][:to_known_uri]
      if known_uri = KnownUri.find_by_uri(params[:autocomplete][:to_known_uri].strip)
        params[:known_uri_relationship][:to_known_uri_id] = known_uri.id
      end
    end
    @known_uri_relationship = KnownUriRelationship.new(params[:known_uri_relationship])
    if @known_uri_relationship.save
      sync_create_known_uri_relationship
      flash[:notice] = I18n.t('known_uri_relationships.created')
    else
      flash[:error] = I18n.t('known_uri_relationships.create_failed')
      flash[:error] << " #{@known_uri_relationship.errors.full_messages.join('; ')}." if @known_uri_relationship.errors.any?
    end
    redirect_to edit_known_uri_path(@known_uri_relationship.from_known_uri)
  end

  # DELETE /known_uri_relationships/:id
  def destroy
    @known_uri_relationship = KnownUriRelationship.find(params[:id])
    @known_uri_relationship_copy = @known_uri_relationship.dup
    @known_uri_relationship.destroy
    sync_destroy_known_uri_relationship
    flash[:notice] = I18n.t('known_uri_relationships.deleted')
    redirect_to request.referer
  end
  
  private
  # synchronization
  def sync_create_known_uri_relationship
    uris_sync_ids = get_uris_sync_ids(@known_uri_relationship.from_known_uri_id,
                                      @known_uri_relationship.to_known_uri_id)
    sync_params = { relationship_uri: @known_uri_relationship.relationship_uri,
                    created_at: @known_uri_relationship.created_at }.reverse_merge(uris_sync_ids)
    options = { user: current_user, object: nil, action_id: SyncObjectAction.create.id,
                type_id: SyncObjectType.known_uri_relationship.id, params: sync_params }       
    SyncPeerLog.log_action(options)
  end
  
  def sync_destroy_known_uri_relationship
    uris_sync_ids = get_uris_sync_ids(@known_uri_relationship_copy.from_known_uri_id,
                                      @known_uri_relationship_copy.to_known_uri_id)
    sync_params = { relationship_uri: @known_uri_relationship_copy.relationship_uri }.reverse_merge(uris_sync_ids)
    options = { user: current_user, object: nil, action_id: SyncObjectAction.delete.id,
                type_id: SyncObjectType.known_uri_relationship.id, params: sync_params }       
    SyncPeerLog.log_action(options)
  end
  
  def get_uris_sync_ids(from_uri_id, to_uri_id)
    sync_ids = {}
    from_uri = KnownUri.find(from_uri_id)
    to_uri = KnownUri.find(to_uri_id)
    sync_ids = { from_uri_origin_id: from_uri.origin_id, 
                 from_uri_site_id: from_uri.site_id,
                 to_uri_origin_id: to_uri.origin_id, 
                 to_uri_site_id: to_uri.site_id } if from_uri && to_uri
  end
end
