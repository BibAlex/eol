class AddObjectFileTypeToFailedFiles < ActiveRecord::Migration
  def change
    add_column :failed_files, :object_file_type, :string
  end
end
