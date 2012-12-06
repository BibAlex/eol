class SyncObjectType < ActiveRecord::Base
  attr_accessible :object_type

  def self.get_user_type
  	self.find_by_object_type('user')
  end
end
