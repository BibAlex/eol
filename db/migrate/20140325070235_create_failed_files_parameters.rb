class CreateFailedFilesParameters < ActiveRecord::Migration
  def change
    create_table :failed_files_parameters do |t|
      t.references :failed_files
      t.string :parameter
      t.string :value

      t.timestamps
    end
  end
end
