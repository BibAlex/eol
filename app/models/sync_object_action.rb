class SyncObjectAction < ActiveRecord::Base
  include Enumerated
  attr_accessible :object_action

  enumerated :object_action, %w(create update update_by_admin activate delete vet remove
                         hide show add swap join save_association remove_association
                        curate_associations rate add_refs leave)
                        
  def is_delete?
    self.object_action == 'delete'
  end 
  
  def is_remove?
    self.object_action == 'remove'  # for relations not independent entities like collection item
  end                      
  
                        
end