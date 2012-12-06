class SyncObjectAction < ActiveRecord::Base
  attr_accessible :object_action

  def self.get_add_user_action
  	self.find_by_object_action('add_user')
  end
end
