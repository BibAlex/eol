class ChangeActionTakenAtInPeerLog < ActiveRecord::Migration
  def up
    rename_column :sync_peer_logs, :action_taken_at_time, :action_taken_at
  end

  def down
  end
end
