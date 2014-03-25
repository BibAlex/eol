class FailedFiles < ActiveRecord::Base  
  attr_accessible :file_type, :file_url, :object_id, :object_type, :output_file_name
       
end
