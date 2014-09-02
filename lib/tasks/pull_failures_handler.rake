require 'image_manipulation'
require "#{Rails.root}/app/helpers/file_helper"
include FileHelper::ClassMethods

namespace :sync do
  
  
  desc 'Download files failures'
  task :download_files => :environment do
    while true
      puts "Checking for new files"
       # fetch records from db
       failed_files = FailedFiles.all
       failed_files.each do |failed_file|
          object = failed_file.object_type.constantize.find(failed_file.object_id)
          if object.updated_at > failed_file.created_at
            delete_failed_file(failed_file)
          else
            handle_failed_file(failed_file, object)
          end
        end
      puts "Sleeping for 10 seconds"
      sleep(10)
    end
  end
  
  def delete_failed_file(failed_file)
    failed_file_parameters =  FailedFilesParameters.where(:failed_files_id => failed_file.id)
    failed_file.destroy
    failed_file_parameters.each { |fp| fp.destroy }
  end
  
  def handle_failed_file(failed_file, object)
    if download_file?(failed_file.file_url, failed_file.output_file_name, failed_file.file_type)
      delete_old_file(failed_file, object)
      update_object_parameters(failed_file, object)
      handle_upload_file(failed_file, object)  
      delete_failed_file(failed_file)
    end
  end
  
  def handle_upload_file(failed_file, object)
    failed_file.object_file_type == "file" ? upload_file(object, SITE_PORT) : upload_object_logo(object)
  end
  
  def delete_old_file(failed_file, object)
    if failed_file.object_file_type == "logo" 
      record_file_name = failed_file.output_file_name
      file_extension = record_file_name[record_file_name.rindex(".")+1, record_file_name.length]
      file_name = failed_file.object_type.downcase.pluralize
      delete_file(object, file_name, file_extension)
    end
  end
  
  def update_object_parameters(failed_file, object)
    failed_file_parameters =  FailedFilesParameters.where(:failed_files_id => failed_file.id)
    failed_file_parameters.each { |fp| object[fp.parameter] = fp.value }
    object.save
  end
end