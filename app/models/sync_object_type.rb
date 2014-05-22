class SyncObjectType < ActiveRecord::Base
  include Enumerated
  attr_accessible :object_type
  
  enumerated :object_type, %w(User common_name Collection content_page Community Comment Ref collection_item
                        data_object collection_job)
end