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
     debugger
     failed_files.each do |record|
       debugger
        if download_file?(record.file_url, record.output_file_name, record.file_type)
          object = record.object_type.constantize.find(record.object_id)
          failed_file_parameters =  FailedFileParameters.find_by_failed_file_id(record.id)
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