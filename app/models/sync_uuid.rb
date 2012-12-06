class SyncUuid < ActiveRecord::Base
  attr_accessible :current_uuid

  def self.get_current_uuid
  	sync_uuid = SyncUuid.last
  	sync_uuid.current_uuid
  end

  def self.set_uuid(new_uuid)
  	sync_uuid = SyncUuid.last
  	sync_uuid.current_uuid = new_uuid
  	sync_uuid.save

  	sync_uuid.current_uuid
  end
end
