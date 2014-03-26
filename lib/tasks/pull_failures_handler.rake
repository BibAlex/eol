require 'image_manipulation'
require "#{Rails.root}/app/helpers/file_helper"
include FileHelper::ClassMethods

namespace :sync do
  
 # include ImageManipulation
  
  desc 'Download files failures'
  task :download_files => :environment do
    while true
      puts "Checking for new files"
      #download_file?(nil,nil,"logo")
      #FailedFiles.download_file?(nil,nil,"logo")
      #download_logo?("https://www.google.com.eg/images/srpr/logo11w.png", "123.png") if file_type == "logo"
     
     # fetch records from db
     failed_files = FailedFiles.all
     failed_files.each do |record|
        if download_file?(record.file_url, record.output_file_name, record.file_type)
          object = record.object_type.constantize.find(record.object_id)
          
            # delete old logo
          old_logo_name = object.logo_file_name
          old_logo_extension = old_logo_name[old_logo_name.rindex(".") + 1, old_logo_name.length]
          if record.file_type == "logo"
            if record.output_file_name[record.output_file_name.rindex(".")+1, record.output_file_name.length] != old_logo_extension
              File.delete("#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{record.object_type.downcase.pluralize}_#{object.id}.#{old_logo_extension}") if File.file? "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{record.object_type.downcase.pluralize}_#{object.id}.#{old_logo_extension}"
            end
          end        
          
          failed_file_parameters =  FailedFilesParameters.where(:failed_files_id => record.id)
          failed_file_parameters.each do |file_paramters|
            object[file_paramters.parameter] = file_paramters.value
          end
          object.save
          upload_file(object)          
        end
      
      end
      
      puts "Sleeping for 10 seconds"
      sleep(10)
    end
  end
end