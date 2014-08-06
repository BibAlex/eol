class SyncObjectType < ActiveRecord::Base
  include Enumerated
  attr_accessible :object_type
  
  enumerated :object_type, %w(User common_name Collection content_page Community Comment Ref collection_item
                        data_object collection_job dummy_type translated_content_page glossary_term search_suggestion
                        agreement contact content_upload)
  def is_dummy?
    self.object_type == 'dummy_type'
  end 
end