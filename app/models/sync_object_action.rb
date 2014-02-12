class SyncObjectAction < ActiveRecord::Base
  attr_accessible :object_action

  def self.get_create_action
    self.find_or_create_by_object_action('create')
  end
  
  def self.get_update_action
    self.find_or_create_by_object_action('update')
  end
  
  def self.get_activate_action
    self.find_or_create_by_object_action('activate')
  end
  
  
end