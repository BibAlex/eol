require 'image_manipulation'
class SyncPeerLog < ActiveRecord::Base
  
  include FileHelper
  include SyncPeerLogHelper
  attr_accessible :action_taken_at_time, :sync_event_id, :sync_object_action_id, :sync_object_id, :sync_object_site_id, :sync_object_type_id, :user_site_id, :user_site_object_id
  has_many :sync_log_action_parameter, :foreign_key => 'peer_log_id'
  belongs_to :sync_object_type, :foreign_key => 'sync_object_type_id'
  belongs_to :sync_object_action, :foreign_key => 'sync_object_action_id'

  def self.log_action(options)
    user = options["user"]
    object = options["object"]
    action_id = options["action_id"]
    type_id = options["type_id"]
    params = options["params"]
    object_site_id = object.site_id unless object.nil?
    object_origin_id = object.origin_id unless object.nil?
    spl = self.create_sync_peer_log("user_site_id" => user.site_id, 
                                    "user_origin_id" => user.origin_id, 
                                    "action_id" => action_id, 
                                    "type_id" => type_id, 
                                    "object_site_id" => object_site_id, 
                                    "object_origin_id" => object_origin_id, 
                                    "params" => params, 
                                    "time" => Time.now)
    if spl
      params.each do |key, value|
          self.create_sync_log_action_parameter(spl.id, key, value)
      end
    end   
  end
  
  
  def process_entry
    parameters = {}
    parameters["user_site_id"] = user_site_id
    parameters["user_site_object_id"] = user_site_object_id
    parameters["sync_object_site_id"] = sync_object_site_id
    parameters["sync_object_id"] = sync_object_id
    parameters["action_taken_at_time"] = action_taken_at_time
      
    sync_log_action_parameter.each do |lap|
      unless lap.param_object_type_id
        parameters[lap.parameter] = lap.value
      else
        # find the object and add it to the hash
        parameters[lap.parameter] = SyncObjectType.find_by_id(lap.param_object_type_id).object_type.constantize.find_by_object_id_and_object_site_id(lap.param_object_id, lap.param_object_site_id)
      end
    end
    
    if parameters.blank?
      # this means that the action depends only on user id and user site id
      parameters[:user_site_id] = user_site_id
      parameters[:user_site_object_id] = user_site_object_id
    end
    
    model_name = SyncObjectType.find_by_id(sync_object_type_id).object_type.downcase
    action_name = SyncObjectAction.find_by_id(sync_object_action_id).object_action.downcase
    if parameters["language"]
      parameters["language"] = Language.find_or_create_by_iso_639_1(parameters["language"], "iso_639_2" => parameters["language"], "iso_639_3" => parameters["language"], "source_form" => parameters["language"])
    else
      parameters["language"] = Language.first
    end
    function_name = "#{action_name}_#{model_name}"
    "SyncPeerLog".constantize.send(function_name, parameters)
  end
  
  private
  def self.create_sync_peer_log(options)
    user_site_id = options["user_site_id"]
    user_site_object_id = options["user_origin_id"]
    sync_object_action_id = options["action_id"]
    sync_object_type_id = options["type_id"]
    sync_object_site_id = options["object_site_id"]
    sync_object_id = options["object_origin_id"]
    parameters = options["params"]
    time = options["time"]
    action = SyncObjectAction.find(sync_object_action_id).object_action unless SyncObjectAction.find(sync_object_action_id).nil?
    
    if (action.include?("delete") )      
     
     sync_peer_logs = SyncPeerLog.find(:all, :conditions => "sync_event_id IS NULL 
                                                   and sync_object_id = #{sync_object_id} and sync_object_site_id = #{sync_object_site_id}")   
      unless (sync_peer_logs.blank?)
        sync_peer_logs.each do |sync_peer_log|
          sync_peer_log.destroy
        end
        return
      end     
    
    elsif (action.include?("remove_item"))
      result = SyncPeerLog.find_by_sql "SELECT p1.peer_log_id as id FROM sync_peer_logs l, sync_log_action_parameters p1, sync_log_action_parameters p2, sync_log_action_parameters p3 WHERE l.sync_event_id IS NULL and p1.peer_log_id = l.id and p2.peer_log_id = l.id and p3.peer_log_id = l.id and l.sync_object_id = #{sync_object_id}  and l.sync_object_site_id = #{sync_object_site_id} and p1.parameter = 'item_id' and p1.value = #{parameters["item_id"]}  and p3.parameter = 'item_site_id' and p3.value = #{parameters["item_site_id"]} and p2.parameter = 'collected_item_type' and p2.value = '#{parameters["collected_item_type"]}'"
      unless (result.blank?)
        sync_peer_log = SyncPeerLog.find(result[0].id)
        unless sync_peer_log.nil?
          sync_peer_log.destroy 
          return
        end
      end     
     end     

    spl = SyncPeerLog.new
    spl.user_site_id = user_site_id   
    spl.user_site_object_id = user_site_object_id
    spl.action_taken_at_time = time
    spl.sync_object_action_id = sync_object_action_id
    spl.sync_object_type_id = sync_object_type_id
    spl.sync_object_site_id = sync_object_site_id
    spl.sync_object_id = sync_object_id
    return spl if spl.save
    return nil
  end
  
  def self.create_sync_log_action_parameter(peer_log_id, key, value)
    slap = SyncLogActionParameter.new
    slap.peer_log_id = peer_log_id
    slap.parameter = key
    slap.value = value
    slap.save
  end
  
  def self.create_user(parameters)
    params = {}
    params["origin_id"] = parameters["sync_object_id"]
    params["site_id"] = parameters["sync_object_site_id"]
    
    parameters.each do |key, value| 
      unless 'user_site_id user_site_object_id sync_object_site_id sync_object_id collection_site_id collection_origin_id action_taken_at_time'.include? key
        params[key] = value
      end
    end

    user = User.create(params)
    #we may remove this part as it always not yet created
    #delete old watch list and create another
    collections = Collection.find_by_sql("SELECT * FROM collections c JOIN collections_users cu ON (c.id = cu.collection_id) 
      WHERE cu.user_id = #{user.id} 
      AND c.special_collection_id = #{SpecialCollection.watch.id}") 
    if collections && collections.count > 0
      Collections_User.find_by_user_id_and_collection_id(user.id, collection.id).delete
      collection[0].delete
    end
    user.build_watch_collection(parameters["collection_site_id"], parameters["collection_origin_id"])
    if user
      EOL::GlobalStatistics.increment('users')  
    end
    
  end
  
  def self.update_user(parameters)
    # find user want to update using user origin id and user origin site id 
    parameters[:user_identity_ids] = parameters["user_identity_ids"].split(",")  if (!(parameters["user_identity_ids"].nil?))
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["origin_id"] = parameters["sync_object_id"]
    parameters.delete("user_site_id")
    parameters.delete("user_site_object_id")
    parameters.delete("sync_object_id")
    parameters.delete("sync_object_site_id") 
    parameters.delete("action_taken_at_time") 
    
    user = User.find_by_origin_id_and_site_id(parameters["origin_id"], parameters["site_id"])
    logo_file_name = parameters["logo_file_name"]
    
    if (!(user.nil?))
      if !(logo_file_name.nil?)
          file_type = logo_file_name[logo_file_name.rindex(".") + 1 , logo_file_name.length ]
          user_logo_name = "users_#{user.id}.#{file_type}"
          file_url = self.get_url(parameters["base_url"], parameters["logo_cache_url"],file_type)
          if download_file?(file_url, user_logo_name, "logo")
          
          # delete old logo
          old_logo_name = user.logo_file_name
          old_logo_extension = old_logo_name[old_logo_name.rindex(".") + 1, old_logo_name.length]
          if file_type != old_logo_extension
            File.delete("#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}users_#{user.id}.#{old_logo_extension}") if File.file? "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}users_#{user.id}.#{old_logo_extension}"
          end
          
          parameters.delete("base_url")
          user.update_attributes(parameters)
          # call log activity
          user.log_activity(:updated_user) 
          # upload user logo
          upload_file(user)
        else
           # add failed file record
          failed_file = FailedFiles.create(:file_url => file_url, :output_file_name => user_logo_name, :file_type => "logo",
                    :object_type => "User" , :object_id => user.id)
          FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_file_name", :value => logo_file_name)
          FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_content_type", :value => parameters["logo_content_type"])
          FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_file_size", :value => parameters["logo_file_size"])
  
          
          #delete redundant parameters 
           ["base_url", "logo_file_name", "logo_cache_url", "logo_content_type", "logo_file_size"].each { |key| parameters.delete key }
            user.update_attributes(parameters)
            # call log activity
            user.log_activity(:updated_user)
        end
     else
         parameters.delete("base_url")
         user.update_attributes(parameters)
        # call log activity
        user.log_activity(:updated_user) 
    end
   end
  end
  
  # update user by admin
  def self.update_by_admin_user(parameters)
    # find user want to update using user origin id and user origin site id 
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["origin_id"] = parameters["sync_object_id"]
    parameters.delete("user_site_id")
    parameters.delete("user_site_object_id")
    parameters.delete("sync_object_id")
    parameters.delete("sync_object_site_id")
    parameters.delete("action_taken_at_time")
    
    user = User.find_by_origin_id_and_site_id(parameters["origin_id"], parameters["site_id"])
    if (!(user.nil?))
      user.update_attributes(parameters)    
      user.add_to_index
    end
  end
  
  def self.activate_user(parameters)
    user = User.where(:site_id => parameters["sync_object_site_id"], :origin_id => parameters["sync_object_id"])
    if user && user.count > 0
      user = user[0]
      user.update_column(:active, true)
      user.update_column(:validation_code, nil)
      user.add_to_index
      if parameters["collection_site_id"]
        user.build_watch_collection(parameters["collection_site_id"], parameters["collection_origin_id"])
      end
    end
  end
  
  # how node site handle create collection action
  def self.create_collection(parameters)
    collection_owner = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    # remove extra parameters which not needed in creating collection 
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["origin_id"] = parameters["sync_object_id"]    
    base = parameters["base"]  
    ["language", "user_site_id", "user_site_object_id", "user_site_object_id", 
      "sync_object_id", "sync_object_site_id", "item_origin_id", "item_site_id",
      "item_type", "item_name", "base", "action_taken_at_time"].each { |key| parameters.delete key }
    collection = Collection.new(parameters)
    collection.save  
    collection.users = [collection_owner] unless collection_owner.nil?           
    
    CollectionActivityLog.create(collection: collection, user: collection_owner, activity: Activity.create) if base
   
  end
  
  
  
   # how node site handle update collection action
  def self.update_collection(parameters)
    collection_owner = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    collection = Collection.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    if collection.updated_at < parameters["updated_at"]
      parameters["site_id"] = parameters["sync_object_site_id"]
      parameters["origin_id"] = parameters["sync_object_id"]   
        
      logo_file_name = parameters["logo_file_name"]
      
      # remove extra parameters which not needed in creating collection
      ["language", "user_site_id", "user_site_object_id", "sync_object_id", "sync_object_site_id", "updated_at", "action_taken_at_time"].each { |key| parameters.delete key }
      
      if(!(collection.nil?))      
        if !(logo_file_name.nil?)
          file_type = logo_file_name[logo_file_name.rindex(".") + 1 , logo_file_name.length ] 
          collection_logo_name = "collections_#{collection.id}.#{file_type}"
          file_url = self.get_url(parameters["base_url"], parameters["logo_cache_url"],file_type)
          if download_file?(file_url, collection_logo_name, "logo")
            # delete old logo
            old_logo_name = collection.logo_file_name
            old_logo_extension = old_logo_name[old_logo_name.rindex(".") + 1, old_logo_name.length]
            if file_type != old_logo_extension
              File.delete("#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}collections_#{collection.id}.#{old_logo_extension}") if File.file? "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}collections_#{collection.id}.#{old_logo_extension}"
            end
            parameters.delete("base_url")
            name_change = parameters[:name] != collection.name
            description_change = parameters[:description] != collection.description
            collection.update_attributes(parameters) 
            # log create collection action
            CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_name }) if name_change
            CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_description }) if description_change
            upload_file(collection)   
          else
            # add failed file record
            failed_file = FailedFiles.create(:file_url => file_url, :output_file_name => collection_logo_name, :file_type => "logo",
                      :object_type => "Collection" , :object_id => collection.id)
            FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_file_name", :value => logo_file_name)
            FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_content_type", :value => parameters["logo_content_type"])
            FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_file_size", :value => parameters["logo_file_size"])
            # delete redundant parameters 
            ["base_url", "logo_file_name", "logo_cache_url", "logo_content_type", "logo_file_size"].each { |key| parameters.delete key }
            name_change = parameters[:name] != collection.name
            description_change = parameters[:description] != collection.description
            collection.update_attributes(parameters) 
            # log create collection action
            CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_name }) if name_change
            CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_description }) if description_change
          end
        else
          parameters.delete("base_url")
          name_change = parameters[:name] != collection.name
          description_change = parameters[:description] != collection.description
          collection.update_attributes(parameters) 
          # log create collection action
          CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_name }) if name_change
          CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_description }) if description_change
        end
      end
    end  
  end
   
  def self.delete_collection(parameters)
    collection = Collection.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    if collection
      collection.unpublish
    end
  end
  
  # create collection job
  def self.create_job_collection(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    origin_collection = Collection.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])

                             
     # create collection job collections
     copied_collections_origin_ids = parameters["copied_collections_origin_ids"].split(",")
     copied_collections_site_ids = parameters["copied_collections_site_ids"].split(",")
     collections = []
     collection_items = []
     copied_collections_origin_ids.count.times do |i|
       collections << Collection.find_by_origin_id_and_site_id(copied_collections_origin_ids[i], copied_collections_site_ids[i])
     end
    
     unless origin_collection.nil?
     # remove items
       collection_items_origin_ids = parameters["collection_items_origin_ids"].split(",")
       collection_items_site_ids = parameters["collection_items_site_ids"].split(",")
       collection_items_names = parameters["collection_items_names"].split(",")
       collection_items_types = parameters["collection_items_types"].split(",")
       collection_items = []
       unless collection_items_origin_ids.nil?
         collection_items_origin_ids.count.times do |i|
           item = collection_items_types[i].constantize.find_by_origin_id_and_site_id(collection_items_origin_ids[i], collection_items_site_ids[i])
           collected_item = CollectionItem.find(:first, :conditions => "collection_id = #{origin_collection.id} and collected_item_id = #{item.id}")
           #collected_item = CollectionItem.find_by_origin_id_and_site_id(collection_items_origin_ids[i], collection_items_site_ids[i] )
           collection_items << collected_item.id unless collected_item.nil?
         end
       end 
     end   
    
     # create collection job                   
     unless (collection_items.blank? and  parameters["command"] == "remove" )               
       CollectionJob.create!(:command => parameters["command"], :user => user,
                            :collection => origin_collection, :item_count => parameters["item_count"],
                            :all_items => parameters["all_items"],
                            :overwrite => parameters["overwrite"],
                            :collection_item_ids =>  collection_items,
                            :collections => collections )
                         
    end
  end
 # add item to collection
  def self.add_item_collection(parameters) 
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    item = parameters["collected_item_type"].constantize.find_by_origin_id_and_site_id(parameters["item_id"], parameters["item_site_id"])
    col = Collection.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    # add item to one collection
    unless col.nil? || item.nil?
      col_item = CollectionItem.create(:name => parameters["collected_item_name"], :collected_item_type => parameters["collected_item_type"],
                                 :collection_id => col.id, :collected_item_id => item.id  )
      if parameters["base_item"]
        EOL::GlobalStatistics.increment('collections')
        CollectionActivityLog.create(collection: col, user_id: user.id,
                           activity: Activity.collect, collection_item: col_item)
      elsif parameters["add_item"]
        CollectionActivityLog.create(collection: col_item.collection, user: user,
                                 activity: Activity.collect, collection_item: col_item)
      end
    end        
  end
  
   # remove item from collection
  def self.remove_item_collection(parameters)
    col = Collection.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    item = parameters["collected_item_type"].constantize.find_by_origin_id_and_site_id(parameters["item_id"], parameters["item_site_id"])
    col_item = CollectionItem.find(:first, :conditions => "collection_id = #{col.id} and collected_item_id = #{item.id}")
    unless col_item.nil?
        col_item.destroy           
    end  
  end
   
     # how node site handle create comment action
  def self.create_comment(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    comment_parent = parameters["parent_type"].constantize.find_by_origin_id_and_site_id(parameters["comment_parent_origin_id"], parameters["comment_parent_site_id"])
    # remove extra parameters which not needed in creating collection 
    unless user.nil?
      parameters["site_id"] = parameters["sync_object_site_id"]
      parameters["origin_id"] = parameters["sync_object_id"]
      parameters["parent_id"] = comment_parent.id   
      [ "user_site_id", "user_site_object_id",  "sync_object_id", "sync_object_site_id", 
        "action_taken_at_time", "language", "comment_parent_origin_id",
        "comment_parent_site_id"].each { |key| parameters.delete key }
      parameters["user_id"] = user.id
      comment = Comment.new(parameters)       
      comment.save!
    end    
  end
  
       # how node site handle update comment action
  def self.update_comment(parameters)
    comment = Comment.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    # remove extra parameters which not needed in creating collection 
    unless comment.nil?
      [ "user_site_id", "user_site_object_id",  "sync_object_id", "sync_object_site_id", 
        "action_taken_at_time", "language"].each { |key| parameters.delete key }
      comment.update_attributes(parameters)
    end    
  end
  
  # how node site handle destroy comment action
  def self.delete_comment(parameters)   
     # update deleted attribute
     self.update_comment(parameters)
  end
   
    # how node site handle hide comment action
  def self.hide_comment(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    comment = Comment.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    # remove extra parameters which not needed in creating collection 
    unless user.nil?
     comment.hide(user)
     Rails.cache.delete('homepage/activity_logs_expiration') if Rails.cache
    end    
  end 
  
  # how node site handle show comment action
  def self.show_comment(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    comment = Comment.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    # remove extra parameters which not needed in creating collection 
    unless user.nil?
     comment.show(user)
     Rails.cache.delete('homepage/activity_logs_expiration') if Rails.cache
    end    
  end 
  
  # how node site handle update collection item action after pull
  def self.update_collection_item(parameters)
    references = parameters["references"]
    col = Collection.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    item = parameters["collected_item_type"].constantize.find_by_origin_id_and_site_id(parameters["item_id"], parameters["item_site_id"])    
    col_item = CollectionItem.find(:first, :conditions => "collection_id = #{col.id} and collected_item_id = #{item.id}")
    if col_item.updated_at < parameters["updated_at"]
      [ "user_site_id", "user_site_object_id",  "sync_object_id", "sync_object_site_id", 
          "action_taken_at_time", "collected_item_type", "item_id",
          "item_site_id", "language", "references", "updated_at"].each { |key| parameters.delete key }
      col_item.update_attributes(parameters) 
      col_item.refs.clear    
      references = references.split("\n") unless references.blank?
      unless references.blank?      
        references.each do |reference|
          if reference.strip != ''
            ref = Ref.find_by_full_reference_and_user_submitted_and_published_and_visibility_id(reference, 1, 1, Visibility.visible.id)
            col_item.refs << ref unless ref.nil?
           end
        end
      end
    end
  end
         
  
  # how node site handle create Ref action after pull
  def self.create_ref(parameters)
    ref = Ref.find_by_full_reference_and_user_submitted_and_published_and_visibility_id(parameters["reference"],1, 1, Visibility.visible.id)
    unless ref
      ref = Ref.new(full_reference: parameters["reference"], user_submitted: true, published: 1, visibility: Visibility.visible)
      ref.save
    end       
  end 
  
  # how node site handle create data object action after pull
  def self.create_data_object(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    references = parameters["references"]
    commit_link = parameters["commit_link"]
    toc_id = nil
    unless parameters["toc_site_id"].nil?
      toc = TocItem.find(:first, :conditions => "site_id = #{parameters["toc_site_id"]} and origin_id = #{parameters["toc_id"]}")
      toc_id = toc.id unless toc.nil?
    end
    link_type_id = nil
    unless parameters["link_type_site_id"].nil?
      link_type = LinkType.find(:first, :conditions => "site_id = #{parameters["link_type_site_id"]} and origin_id = #{parameters["link_type_id"]}")
      link_type_id = link_type.id  unless link_type.nil?
    end
    
    parameters = parameters.reverse_merge("origin_id" => parameters["sync_object_id"],
                                          "site_id" => parameters["sync_object_site_id"])                                                           
    [ "user_site_id", "user_site_object_id",  "sync_object_id", "sync_object_site_id", 
      "action_taken_at_time", "language", "commit_link",  "taxon_concept_origin_id",
      "taxon_concept_site_id", "references", "link_type_id", "toc_id",
      "toc_site_id", "link_type_site_id"].each { |key| parameters.delete key }    
    
    data_object = DataObject.create_user_text(parameters, user: user,
                                               taxon_concept: taxon_concept, toc_id: toc_id,
                                               link_type_id: link_type_id, link_object: commit_link)
     
    references = references.split("\r\n") unless references.blank?
      unless references.blank?      
        references.each do |reference|
          if reference.strip != ''
            ref = Ref.find_by_full_reference_and_user_submitted_and_published_and_visibility_id(reference, 1, 1, Visibility.visible.id)
            data_object.refs << ref unless ref.nil?
           end
        end
      end
                                                 
    user.log_activity(:created_data_object_id, value: data_object.id,
                                taxon_concept_id: taxon_concept.id)     
    data_object.log_activity_in_solr(keyword: 'create', user: user, taxon_concept: taxon_concept) 
  end 
  
 
  def self.get_url(base_url, cache_url,file_type)
    file_type = "jpg" if file_type == "jpeg"
    file_url = "#{cache_url[0,4]}\/#{cache_url[4,2]}\/#{cache_url[6,2]}\/#{cache_url[8,2]}\/#{cache_url[10,5]}.#{file_type}"
    return base_url + file_url
  end
  
  
  def self.create_common_name(parameters)
    taxon_concept = TaxonConcept.where(:site_id => parameters["taxon_concept_site_id"], :origin_id => parameters["taxon_concept_origin_id"])
    if taxon_concept && taxon_concept.count > 0
      taxon_concept = taxon_concept[0]     
      user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"],parameters["user_site_id"])
      taxon_concept.add_common_name_synonym(parameters["string"], agent: user.agent,
                                            language: parameters["language"],
                                            vetted: Vetted.trusted,
                                            site_id: parameters["name_site_id"],
                                            name_origin_id: parameters["name_origin_id"],
                                            synonym_site_id: parameters["sync_object_site_id"],
                                            synonym_origin_id: parameters["sync_object_id"])
      taxon_concept.reindex_in_solr
      # expire_taxa([taxon_concept.id])
    end
  end
 
  def self.delete_common_name(parameters)
    synonym = Synonym.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    if synonym && taxon_concept
      tcn = TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(synonym.id, taxon_concept.id)
      taxon_concept.delete_common_name(tcn)
      taxon_concept.reindex_in_solr
    end
  end
 
  def self.vet_common_name(parameters)
    language_id = parameters["language"].id
    name_id = Name.find_by_string(parameters["string"]).id
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    vetted = Vetted.find_or_create_by_view_order(parameters["vetted_view_order"])
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    found = taxon_concept.vet_common_name(language_id: language_id, name_id: name_id, vetted: vetted, user: user,
                                        date: parameters["action_taken_at_time"])
    if found
      user.log_activity(:vetted_common_name, taxon_concept_id: taxon_concept.id, value: name_id)
      taxon_concept.reindex_in_solr
    end
  end
 
  def self.update_common_name(parameters)
    name = Name.find_by_string(parameters["string"])
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    language = parameters["language"]
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    taxon_concept.add_common_name_synonym(name.string,
                                          agent: user.agent,
                                          language: language,
                                          preferred: 1,
                                          vetted: Vetted.trusted,
                                          site_id: name.site_id,
                                          date: parameters["action_taken_at_time"],
                                          is_preferred: parameters["is_preferred"])
    user.log_activity(:updated_common_names, taxon_concept_id: taxon_concept.id)
  end
  
  def self.create_community(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    collection = Collection.find_by_origin_id_and_site_id(parameters["collection_origin_id"], parameters["collection_site_id"])
    community = Community.create(:name => parameters["community_name"], 
                               :description => parameters["community_description"], 
                               :origin_id => parameters["sync_object_id"], 
                               :site_id => parameters["sync_object_site_id"])
    if collection
      collection.communities << community
    end
    community.initialize_as_created_by(user)
    EOL::GlobalStatistics.increment('communities') if community.published?
    #add logo
    self.handle_community_logo(community, parameters)
    options = {}
    options[:user] = user
    options[:without_flash] = true
    auto_collect_helper(community, options)
    community.collections.each do |focus|
      auto_collect_helper(focus, options)
    end
    opts = {}
    opts["user"] = user
    opts["community"] = community
    log_community_action(:create, opts)
  end
  
  def self.update_community(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    community = Community.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    if community
      community.update_column(:name, parameters["community_name"]) if parameters["name_change"]
      community.update_column(:description, parameters["community_description"]) if parameters["description_change"]
      #UPDATE logo
      self.handle_community_logo(community, parameters)
      opts = {}
      opts["user"] = user
      opts["community"] = community
      if parameters["name_change"] == "1"
        log_community_action(:change_name, opts)
      end 
      opts = {}
      opts["user"] = user
      opts["community"] = community
      if parameters["description_change"] == "1"
        log_community_action(:change_description, opts)
      end 
    end
  end
  
  def self.delete_community(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    community = Community.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    if community
      community.update_column(:published, false)
      community.collection.update_column(:published, false) rescue nil
      if user
        community.remove_member(user)
        community.save
      end
      EOL::GlobalStatistics.decrement('communities')
      opts = {}
      opts["user"] = user
      opts["community"] = community
      log_community_action(:delete, opts)
    end
  end
  
  def self.join_community(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    community = Community.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    if community && user
      member = community.add_member(user)
      options = {}
      options[:user] = user
      options[:annotation] = I18n.t(:user_joined_community_on_date, date: I18n.l(parameters["action_taken_at_time"]),
      username: user.full_name)
      options[:without_flash] = true
      auto_collect_helper(community, options)
      community.collections.each do |focus|
        auto_collect_helper(focus,options)
      end
      opts = {}
      opts["user"] = user
      opts["community"] = community
      opts["member_id"] = user.id
      log_community_action(:join, opts)
    end
    
  end
  
  def self.leave_community(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    community = Community.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    if community && user
      community.remove_member(user)
      opts = {}
      opts["user"] = user
      opts["community"] = community
      opts["member_id"] = user.id
      log_community_action(:leave, opts)
    end
  end
  
  def self.save_association_data_object(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    data_object = DataObject.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    he = HierarchyEntry.find_by_origin_id_and_site_id(parameters["hierarchy_entry_origin_id"], parameters["hierarchy_entry_site_id"])
    cdohe = data_object.add_curated_association(user, he)
    data_object.update_solr_index
    options = {}
    options["data_object"] = data_object
    options["user"] = user
    log_data_object_action(cdohe, :add_association, options)
  end
  
  def self.remove_association_data_object(parameters)
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    data_object = DataObject.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    he = HierarchyEntry.find_by_origin_id_and_site_id(parameters["hierarchy_entry_origin_id"], parameters["hierarchy_entry_site_id"])
    cdohe = data_object.remove_curated_association(user, he)
    data_object.update_solr_index
    options = {}
    options["data_object"] = data_object
    options["user"] = user
    log_data_object_action(cdohe, :remove_association, options)
  end
  
  def self.curate_associations_data_object(parameters)
    
    user = User.find_by_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    data_object = DataObject.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    
    visibility = parameters["visibility_label"] ? Visibility.find(TranslatedVisibility.find_by_language_id_and_label(parameters["language"].id, parameters["visibility_label"]).visibility_id) : nil
    untrust_reasons = parameters["untrust_reasons"] ? get_objects_ids(parameters["untrust_reasons"], "UntrustReason") : nil
    hide_reasons = parameters["hide_reasons"] ? get_objects_ids(parameters["hide_reasons"], "UntrustReason"): nil
    comment = (parameters["curation_comment_origin_id"] && parameters["curation_comment_site_id"]) ? Comment.find_by_origin_id_and_site_id(parameters["curation_comment_origin_id"], parameters["curation_comment_site_id"]) : nil
      
    association = data_object.data_object_taxa.find {|item| item.taxon_concept.origin_id == taxon_concept.origin_id && item.taxon_concept.site_id == taxon_concept.site_id}
    
    
    
    curation = Curation.new(
        association: association,
        user: user,
        vetted: Vetted.find_by_view_order(parameters["vetted_view_order"]),
        visibility: visibility,
        comment: comment, 
        untrust_reason_ids: untrust_reasons,
        hide_reason_ids: hide_reasons)
    curation.curate
    DataObjectCaching.clear(data_object)
    options = {}
    options[:user] = user
    options[:without_flash] = true
    auto_collect_helper(data_object, options) 
    data_object.reindex
  end
  
  def self.get_objects_ids(objects_labels, object_type)
    objects_ids = []
    objects_labels = objects_labels.split(",")
    if objects_labels
      objects_labels.each do |object_label|
        object = object_type.constantize.find_by_class_name(object_label)
        objects_ids << object.id.to_s if object
      end
    end  
    objects_ids  
  end
  
  def self.handle_community_logo(community, parameters)
    logo_file_name = parameters["logo_file_name"]
    if !(logo_file_name.nil?)
      file_type = logo_file_name[logo_file_name.rindex(".") + 1 , logo_file_name.length ]
      community_logo_name = "communities_#{community.id}.#{file_type}"
      file_url = self.get_url(parameters["base_url"], parameters["logo_cache_url"],file_type)
      if download_file?(file_url, community_logo_name, "logo")
        community.update_column(:logo_file_name, community_logo_name)
        community.update_column(:logo_content_type, parameters["logo_content_type"])
        community.update_column(:logo_file_size, parameters["logo_file_size"])
        # upload logo
        upload_file(community)
      else
         # add failed file record
        failed_file = FailedFiles.create(:file_url => file_url, :output_file_name => community_logo_name, :file_type => "logo",
                  :object_type => "Community" , :object_id => community.id)
        FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_file_name", :value => logo_file_name)
        FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_content_type", :value => parameters["logo_content_type"])
        FailedFilesParameters.create(:failed_files_id => failed_file.id, :parameter => "logo_file_size", :value => parameters["logo_file_size"])
      end
    end
  end
#  def self.find_invitees(parameters)
#    invitees = []
#    parameters.each do |key,value|
#      if key.include? "invitee_"
#        invitees << value
#      end
#    end
#    invitees
#  end
  
end
