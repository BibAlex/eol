class CreateFailedFiles < ActiveRecord::Migration
  def change
    create_table :failed_files do |t|
      t.string :file_url
      t.string :output_file_name
      t.string :file_type
      t.string :object_type
      t.integer :object_id

      t.timestamps
    end
  end
end
