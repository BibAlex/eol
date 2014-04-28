class SyncObjectType < ActiveRecord::Base
  attr_accessible :object_type

  def self.get_user_type
    self.find_or_create_by_object_type('User')
  end
  
  def self.get_common_name_type
    self.find_or_create_by_object_type('common_name')
  end 
  
  def self.get_collection_type
    self.find_or_create_by_object_type('Collection')
  end
  
  def self.get_comment_type
    self.find_or_create_by_object_type('Comment')
  end
  
  def self.get_ref_type
    self.find_or_create_by_object_type('Ref')
  end
  
  def self.get_collection_item_type
    self.find_or_create_by_object_type('collection_item')
  end
  
end

