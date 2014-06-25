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
       failed_files.each do |record|
          object = record.object_type.constantize.find(record.object_id)
          failed_file_parameters =  FailedFilesParameters.where(:failed_files_id => record.id)
          if object.updated_at > record.created_at
            #delete this record           
            record.destroy
            failed_file_parameters.each { |fp| fp.destroy }
          else
            if download_file?(record.file_url, record.output_file_name, record.file_type)
              
              # delete old logo
              record_file_name = record.output_file_name
              file_type = record_file_name[record_file_name.rindex(".")+1, record_file_name.length]
              file_name = record.object_type.downcase.pluralize
              delete_file(object, file_name, file_type)            
              
              # update object parameters
              failed_file_parameters.each { |fp| object[fp.parameter] = fp.value }
              object.save
              
              # upload file
              upload_file(object)  
                   
              #delete this record           
              record.destroy
              failed_file_parameters.each { |fp| fp.destroy }
            end
          end
        end
      puts "Sleeping for 10 seconds"
      sleep(10)
    end
  end
end