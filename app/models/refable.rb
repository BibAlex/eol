module Refable
  def add_ref(reference, user)
    if reference.strip != ''
      ref = Ref.find_by_full_reference_and_user_submitted_and_published_and_visibility_id(reference, 1, 1, Visibility.visible.id)
      if (ref)
        self.refs << ref
      else
        created_ref =  Ref.new(full_reference: reference, user_submitted: true, published: 1, visibility: Visibility.visible)
        sync_create_ref(reference, user)
        self.refs << created_ref
      end
    end
  end
  
  def sync_create_ref(reference, user)
    sync_params = {reference: reference}
    options = {user: user, object: nil, action_id: SyncObjectAction.create.id,
              type_id: SyncObjectType.ref.id, params: sync_params}           
    SyncPeerLog.log_action(options)
  end
end
