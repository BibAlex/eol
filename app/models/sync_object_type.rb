class SyncObjectType < ActiveRecord::Base
  attr_accessible :object_type

  def self.get_user_type
    self.find_or_create_by_object_type('User')
  end
  
   def self.get_collection_type
    self.find_or_create_by_object_type('Collection')
  end
    
end