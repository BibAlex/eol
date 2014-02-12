class SyncUuid < ActiveRecord::Base
  attr_accessible :current_uuid

  def self.get_current_uuid
    sync_uuid = SyncUuid.last

    if sync_uuid
      sync_uuid.current_uuid
    else
      init_uuid.current_uuid
    end
  end

  def self.set_uuid(new_uuid)
    sync_uuid = SyncUuid.last
    unless sync_uuid
      sync_uuid = init_uuid
    end
    sync_uuid.current_uuid = new_uuid
    sync_uuid.save
    sync_uuid.current_uuid
  end
  
  def self.init_uuid
    sync_uuid = SyncUuid.new
    sync_uuid.current_uuid = INIT_UUID
    sync_uuid.save

    sync_uuid
  end
end