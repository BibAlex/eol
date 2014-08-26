require 'image_manipulation'
class SyncPeerLog < ActiveRecord::Base
  
  include FileHelper
  include SyncPeerLogHelper
  
  attr_accessible :action_taken_at, :sync_event_id, :sync_object_action_id, :sync_object_id, :sync_object_site_id, :sync_object_type_id, :user_site_id, :user_site_object_id
  has_many :sync_log_action_parameter, :foreign_key => 'peer_log_id'
  belongs_to :sync_object_type, :foreign_key => 'sync_object_type_id'
  belongs_to :sync_object_action, :foreign_key => 'sync_object_action_id'

  def self.log_action(options)
    user = options[:user]
    object = options[:object]    
    params = options[:params]
    if object
      object_site_id = object.site_id
      object_origin_id = object.origin_id
    end    

    spl = self.create_sync_peer_log(user_site_id: user.site_id, user_origin_id: user.origin_id, 
                                    action_id: options[:action_id], type_id: options[:type_id], 
                                    object_site_id: object_site_id,  object_origin_id: object_origin_id, 
                                    params: params,  time: Time.now)
                                    
    create_sync_log_action_parameters(spl.id, params) if spl
  end
  
  
  def process_entry
    parameters = {}
    parameters[:user_site_id] = user_site_id
    parameters[:user_site_object_id] = user_site_object_id
    parameters[:sync_object_site_id] = sync_object_site_id
    parameters[:sync_object_id] = sync_object_id
    parameters[:action_taken_at] = action_taken_at
      
    sync_log_action_parameter.each do |lap|
      unless lap.param_object_type_id
        parameters[lap.parameter.to_sym] = lap.value
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
    if parameters[:language]
      parameters[:language] = Language.find_or_create_by_iso_639_1(parameters[:language], "iso_639_2" => parameters[:language], "iso_639_3" => parameters[:language], "source_form" => parameters[:language])
    else
      parameters[:language] = Language.first
    end
    function_name = "#{action_name}_#{model_name}"
    "SyncPeerLog".constantize.send(function_name, parameters)
  end
  
  def self.delete_keys(keys, hash)
    keys.each { |key| hash.delete key }
    hash
  end
  
  private
    
  def self.create_sync_peer_log(options)
    user_site_id = options[:user_site_id]
    user_site_object_id = options[:user_origin_id]
    sync_object_action_id = options[:action_id]
    sync_object_type_id = options[:type_id]
    sync_object_site_id = options[:object_site_id]
    sync_object_id = options[:object_origin_id]
    parameters = options[:params]
    time = options[:time]
    action = SyncObjectAction.find(sync_object_action_id) unless SyncObjectAction.find(sync_object_action_id).nil?

    # remove peer logs of the object that is created and then removed locally
    local_peer_logs = get_local_changes(action, sync_object_site_id, sync_object_id, parameters)
    if local_peer_logs.empty?
      SyncPeerLog.create(user_site_id: user_site_id, user_site_object_id: user_site_object_id,
                         action_taken_at: time, sync_object_action_id: sync_object_action_id,
                         sync_object_type_id: sync_object_type_id, sync_object_site_id: sync_object_site_id,
                         sync_object_id: sync_object_id)
    else
      delete_local_changes(local_peer_logs)
      return nil
    end
  end
  
  def self.get_local_changes(action, sync_object_site_id, sync_object_id, parameters)
    sync_peer_logs = []
    if (action.is_delete?)  
      sync_peer_logs = SyncPeerLog.where("sync_object_id = ? and sync_object_site_id = ? 
                                          and sync_event_id IS NULL", sync_object_id, sync_object_site_id) 
    
    elsif (action.is_remove?)
      sync_peer_logs = SyncPeerLog.joins(:sync_log_action_parameter).where("sync_object_id = ? and sync_object_site_id = ? and parameter = ? and value = ? and sync_event_id IS NULL", sync_object_id, sync_object_site_id, 'item_id', parameters["item_id"])
    elsif (action.is_show?)
      sync_peer_logs = SyncPeerLog.where("sync_object_id = ? and sync_object_site_id = ? 
                                          and sync_object_action_id = ?  and sync_event_id IS NULL", sync_object_id, sync_object_site_id,
                                          SyncObjectAction.hide.id) 
    end     
     sync_peer_logs
  end
  
  def self.delete_local_changes(sync_peer_logs)    
    sync_peer_logs.each do |sync_peer_log|
      log_action_parameters = SyncLogActionParameter.where('peer_log_id = ?', sync_peer_log.id)
      sync_peer_log.destroy
      log_action_parameters.each do |log_action_parameter|
        log_action_parameter.destroy
      end
    end
  end
  
  def self.create_sync_log_action_parameters(peer_log_id, params)
    params.each do |key, value|
      SyncLogActionParameter.create(peer_log_id: peer_log_id, parameter: key, value: value)      
    end
  end
  
  def self.create_user(parameters)
    parameters[:origin_id] = parameters[:sync_object_id]
    parameters[:site_id] = parameters[:sync_object_site_id]
    collection_site_id = parameters[:collection_site_id]
    collection_origin_id = parameters[:collection_origin_id]
    
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :collection_site_id, :collection_origin_id, :action_taken_at],parameters)
    user = User.create!(parameters)
    #we may remove this part as it always not yet created
    #delete old watch list and create another
    collection = user.watch_collection
    if collection
      collection.update_attributes(origin_id: collection_origin_id, site_id: collection_site_id)
    else
      user.build_watch_collection(collection_site_id, collection_origin_id)
    end
    if user
      EOL::GlobalStatistics.increment('users')  
    end
  end
  
  def self.update_user(parameters)
    object_logo_parameters = {logo_cache_url: parameters[:logo_cache_url],
                              logo_file_name: parameters[:logo_file_name],
                              logo_content_type: parameters[:logo_content_type],
                              logo_file_size: parameters[:logo_file_size]}
    parameters[:user_identity_ids] = parameters[:user_identity_ids].split(",")  if parameters[:user_identity_ids]
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:origin_id] = parameters[:sync_object_id]
    base_url = parameters[:base_url]
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :base_url, :logo_cache_url, 
                              :logo_file_name, :logo_content_type, :logo_file_size],parameters)
                                       
    user = User.find_site_specific(parameters[:origin_id], parameters[:site_id])
    if user
      user.update_attributes(parameters)
      # call log activity
      user.log_activity(:updated_user)
      
      parameters[:base_url] = base_url
      download_object_file("User", user, parameters.reverse_merge(object_logo_parameters), "logo")
   end
  end
  
  def self.download_object_file(object_type, object, parameters, object_file_type)
    file_name = parameters[:logo_file_name]
    if file_name
      base_url = parameters[:base_url]
      cache_url = parameters[:logo_cache_url]
      directory_name = object_type.downcase.pluralize
      file_type = file_name[file_name.rindex(".") + 1 , file_name.length ]
      file_name = object_file_type == "file" ? "#{object.id}.#{file_type}" : "#{directory_name}_#{object.id}.#{file_type}"
      file_url = self.get_url(base_url, cache_url,file_type)
      if download_file?(file_url, file_name, object_file_type)
        if parameters[:is_file]
          update_file_parameters(object, parameters[:logo_file_name], parameters[:logo_content_type],
                                 parameters[:logo_file_size])
        else
          delete_object_file(object, directory_name, file_type)
          update_logo_parameters(object, parameters[:logo_file_name], parameters[:logo_content_type],
                                 parameters[:logo_file_size])
        end
        upload_object_file(object, object_file_type)
      else
        log_failed_download(file_url, file_name, file_type, object_type, object, parameters)
      end
    end
  end
  
  def self.update_logo_parameters(object, logo_name, logo_content_type, logo_file_size)
    object.update_column(:logo_file_name, logo_name)
    object.update_column(:logo_content_type, logo_content_type)
    object.update_column(:logo_file_size, logo_file_size)
  end
  
  def self.update_file_parameters(object, attachment_name, attachment_content_type, attachment_file_size)
    object.update_column(:attachment_file_name, attachment_name)
    object.update_column(:attachment_content_type, attachment_content_type)
    object.update_column(:attachment_file_size, attachment_file_size)
  end
  
  def self.upload_object_file(object, object_file_type)
    object_file_type == "file" ? upload_file(object, SITE_PORT) : upload_object_logo(object)
  end
  
  def self.delete_object_file(object, directory_name, file_type)
    delete_file(object, directory_name, file_type)
  end
  
  def self.log_failed_download(file_url, logo_name, file_type, object_type, object, parameters)
    failed_file = FailedFiles.create(file_url: file_url, output_file_name: logo_name, file_type: file_type ,
                object_type: object_type , object_id: object.id)
    FailedFilesParameters.create(failed_files_id: failed_file.id, parameter: "logo_file_name", value: parameters[:logo_file_name])
    FailedFilesParameters.create(failed_files_id: failed_file.id, parameter: "logo_content_type", value: parameters[:logo_content_type])
    FailedFilesParameters.create(failed_files_id: failed_file.id, parameter: "logo_file_size", value: parameters[:logo_file_size])
  end
  
  # update user by admin
  def self.update_by_admin_user(parameters)
    # find user want to update using user origin id and user origin site id 
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:origin_id] = parameters[:sync_object_id]
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                       :action_taken_at],parameters)
    
    user = User.find_site_specific(parameters[:origin_id], parameters[:site_id])
    if user
      user.update_attributes(parameters)    
      user.add_to_index
    end
  end
  
  def self.activate_user(parameters)
    user = User.where(site_id: parameters[:sync_object_site_id], origin_id: parameters[:sync_object_id])
    if user && !(user.empty?)
      user = user.first
      user.update_attributes(active: true, validation_code: nil)
      user.add_to_index
      if parameters[:collection_site_id]
        user.build_watch_collection(parameters[:collection_site_id], parameters[:collection_origin_id])
      end
    end
  end
  
  # how node site handle create collection action
  def self.create_collection(parameters)
    collection_owner = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    # remove extra parameters which not needed in creating collection 
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:origin_id] = parameters[:sync_object_id]    
    base = parameters[:base]  
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language , :base],parameters)
    
    collection = Collection.new(parameters)
    collection.save  
    collection.users = [collection_owner] unless collection_owner.nil?           
    CollectionActivityLog.create(collection: collection, user: collection_owner, activity: Activity.create) if base
  end
  
  
  
   # how node site handle update collection action
  def self.update_collection(parameters)
    object_logo_parameters = {logo_cache_url: parameters[:logo_cache_url],
                              logo_file_name: parameters[:logo_file_name],
                              logo_content_type: parameters[:logo_content_type],
                              logo_file_size: parameters[:logo_file_size]}
                              
    collection_owner = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    collection = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if collection
      if collection.older_than?(parameters[:updated_at], "updated_at")
        parameters[:site_id] = parameters[:sync_object_site_id]
        parameters[:origin_id] = parameters[:sync_object_id] 
        base_url = parameters[:base_url]  
        # remove extra parameters which not needed in creating collection
        parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                  :action_taken_at, :language , :updated_at, :base_url,
                                  :logo_cache_url, :logo_file_name, :logo_content_type,
                                  :logo_file_size],parameters)

        collection.update_attributes(parameters)
        name_changed = parameters[:name] != collection.name
        description_changed = parameters[:description] != collection.description
        # log create collection action
        CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_name }) if name_changed
        CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_description }) if description_changed
         
        parameters[:base_url] = base_url
        download_object_file("Collection", collection, parameters.reverse_merge(object_logo_parameters), "logo")        
      end
    end  
  end
  
   
  def self.delete_collection(parameters)
    collection = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if collection
      collection.unpublish
    end
  end
  
  # create collection job
  def self.create_collection_job(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    origin_collection = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    unique_job_id = parameters[:unique_job_id]
    dummy_type_id = SyncObjectType.dummy_type.id
    # find copied items
    peer_logs = SyncPeerLog.joins(:sync_log_action_parameter).where("sync_object_type_id = ?  and parameter = ? and value = ?", 
               dummy_type_id,  "unique_job_id", unique_job_id)
     collection_items = get_collection_items_ids(peer_logs, origin_collection)
     collections = get_collections_ids(peer_logs) unless parameters[:command] == "remove"
     
     # create collection job  
    if user.can_edit_collection?(origin_collection)                 
     unless (collection_items.blank? and  parameters["command"] == "remove")
       collection_job = CollectionJob.create!(command: parameters[:command], user: user,
                             collection: origin_collection, item_count: parameters[:item_count],
                             all_items: parameters[:all_items],
                             overwrite: parameters[:overwrite],
                             collection_item_ids: collection_items,
                             collection_ids: collections)
       collection_job.run if collection_job
     end
    end
  end
  
  def self.get_collection_items_ids(peer_logs, origin_col)
    collected_items_ids = []
    peer_logs.each do |peer_log|
      item_type_action_parameter = SyncLogActionParameter.where("peer_log_id = ? and parameter = ? ", peer_log.id, "collected_item_type")
      item_type = item_type_action_parameter.first.value if item_type_action_parameter.first
      item_origin_id_action_parameter = SyncLogActionParameter.where("peer_log_id = ? and parameter = ? ", peer_log.id, "item_id")
      item_origin_id = item_origin_id_action_parameter.first.value if item_origin_id_action_parameter.first
      item_site_id_action_parameter = SyncLogActionParameter.where("peer_log_id = ? and parameter = ? ", peer_log.id, "item_site_id")
      item_site_id = item_site_id_action_parameter.first.value if item_site_id_action_parameter.first
      item = item_type.constantize.find_site_specific(item_origin_id, item_site_id)
      collected_item = CollectionItem.where("collection_id = ? and collected_item_id = ?", origin_col.id, item.id)
      collected_items_ids << collected_item.first.id if collected_item.first
    end
    collected_items_ids = collected_items_ids.uniq
    collected_items_ids.map(&:to_s)
  end
  
  def self.get_collections_ids(peer_logs)
    collections_ids = []
    peer_logs.each do |peer_log|
      collection = Collection.find_site_specific(peer_log.sync_object_id, peer_log.sync_object_site_id)
      collections_ids << collection.id if collection
    end
    collections_ids = collections_ids.uniq
    collections_ids.map(&:to_s)
  end
  
 # add item to collection
  def self.add_collection_item(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    item = parameters[:collected_item_type].constantize.find_site_specific(parameters[:item_id], parameters[:item_site_id])
    col = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    # add item to one collection
    if col && item
      if parameters[:base_item]
        options = {user: user}
        auto_collect_helper(col, options)
        add_item_to_collection(col, item)
        res = CollectionItem.where("collection_id = ? and collected_item_id = ?", col.id, item.id)
        col_item = res.nil? ? nil: res.first
      elsif parameters[:add_item]
        col_item = CollectionItem.create(name: parameters[:collected_item_name], collected_item_type: parameters[:collected_item_type],
                                         collection_id: col.id, collected_item_id: item.id)
        CollectionActivityLog.create(collection: col_item.collection, user: user,
                                  activity: Activity.collect, collection_item: col_item)
        col.updated_at = parameters[:collection_updated_at]
        col.save
      end
    end
  end
   
     # how node site handle create comment action
  def self.create_comment(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    comment_parent = parameters[:parent_type].constantize.find_site_specific(parameters[:comment_parent_origin_id], parameters[:comment_parent_site_id])
    
    parent_comment = Comment.find_site_specific(parameters[:parent_comment_origin_id], parameters[:parent_comment_site_id]) if parameters[:parent_comment_origin_id]
    # remove extra parameters which not needed in creating collection 
    if user
      parameters = parameters.reverse_merge(site_id: parameters[:sync_object_site_id],
                                            origin_id: parameters[:sync_object_id],
                                            parent_id: comment_parent.id,
                                            user_id: user.id)
      parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_id, :sync_object_site_id, :action_taken_at,
                                         :language, :comment_parent_origin_id, :comment_parent_site_id, 
                                         :parent_comment_origin_id, :parent_comment_site_id],parameters)
      parameters[:reply_to_id] = parent_comment.id if parent_comment
      comment = Comment.new(parameters)       
      comment.save!
    end    
  end
  
       # how node site handle update comment action
  def self.update_comment(parameters)
    comment = Comment.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if comment
       # if it is newer take it else keep the old one
      if comment.older_than?(parameters[:updated_at], "text_last_updated_at")
        parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_id, :sync_object_site_id, 
                                           :action_taken_at, :language],parameters)
        comment.update_attributes(parameters)
        comment.update_attributes(text_last_updated_at: parameters[:updated_at])
      end
    end    
  end
  
  # how node site handle destroy comment action
  def self.delete_comment(parameters)   
     # update deleted attribute
     comment = Comment.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if comment
      # if it is newer take it else keep the old one
      parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_id, :sync_object_site_id, 
                                         :action_taken_at, :language],parameters)
      comment.update_attributes(parameters)
    end
      update_comment(parameters)
  end
   
    # how node site handle hide comment action
  def self.hide_comment(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    comment = Comment.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if user
      if comment
        comment.hide(user)
        EOL::ActivityLog.clear_expiration_cache
      end
    end    
  end 
  
  # how node site handle show comment action
  def self.show_comment(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    comment = Comment.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if user
      if comment
        if (comment.was_visible_before?(parameters[:visible_at]))
          comment.show(user)
          comment.update_attributes(visible_at: parameters[:visible_at])
          EOL::ActivityLog.clear_expiration_cache
        end
      end
    end    
  end 
  
  # how node site handle update collection item action after pull
  def self.update_collection_item(parameters)
    col = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    item = parameters[:collected_item_type].constantize.find_site_specific(parameters[:item_id], parameters[:item_site_id])    
    col_item = CollectionItem.where("collection_id = ? and collected_item_id = ?", col.id, item.id).first
    if col_item
      if col_item.older_than?(parameters[:updated_at], "updated_at")
        parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                           :action_taken_at, :language , :updated_at, :collected_item_type,
                                           :item_id, :item_site_id, :references],parameters)
        col_item.update_attributes(parameters) 
      end
    end
  end
  
  
  def self.add_refs_collection_item(parameters)
    references = parameters[:references]
    col = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    item = parameters[:collected_item_type].constantize.find_site_specific(parameters[:item_id], parameters[:item_site_id])    
    col_item = CollectionItem.where("collection_id = ? and collected_item_id = ?", col.id, item.id).first
    if col_item
      col_item.refs.clear
      add_refs(col_item, references) 
    end   
  end
  
  def self.add_refs(object, references)
    references = references.split("\n") unless references.blank?
    unless references.blank?      
      references.each do |reference|
        if reference.strip != ''
          ref = Ref.find_by_full_reference_and_user_submitted_and_published_and_visibility_id(reference, 1, 1, Visibility.visible.id)
            object.refs << ref unless ref.nil?
        end
      end
    end
  end
         
  
  # how node site handle create Ref action after pull
  def self.create_ref(parameters)
    ref = Ref.find_by_full_reference_and_user_submitted_and_published_and_visibility_id(parameters[:reference],1, 1, Visibility.visible.id)
    unless ref
      if parameters[:reference]
        ref = Ref.new(full_reference: parameters[:reference], user_submitted: true, published: 1, visibility: Visibility.visible)
        ref.save
      end
    end       
  end 
  
  # how node site handle create data object action after pull
  def self.create_data_object(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    #references = parameters[:references]
    commit_link = parameters[:commit_link]
    toc_id = nil
    if parameters[:toc_site_id]
      toc = TocItem.where("site_id = ? and origin_id = ?", parameters[:toc_site_id], parameters[:toc_id]).first
      toc_id = toc.id if toc
    end
    link_type_id = nil
    if parameters[:link_type_site_id]
      link_type = LinkType.find("site_id = ? and origin_id = ?", parameters[:link_type_site_id], parameters[:link_type_id]).first
      link_type_id = link_type.id  if link_type
    end
    
    parameters = parameters.reverse_merge(origin_id: parameters[:sync_object_id],
                                          site_id: parameters[:sync_object_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                       :action_taken_at, :language , :commit_link,
                                       :taxon_concept_origin_id, :taxon_concept_site_id,
                                       :references, :link_type_id, :toc_id, :toc_site_id,
                                       :link_type_site_id],parameters)                                                         
    
    data_object = DataObject.create_user_text(parameters, user: user,
                                               taxon_concept: taxon_concept, toc_id: toc_id,
                                               link_type_id: link_type_id, link_object: commit_link)
     
    user.log_activity(:created_data_object_id, value: data_object.id,
                                taxon_concept_id: taxon_concept.id)     
    data_object.log_activity_in_solr(keyword: 'create', user: user, taxon_concept: taxon_concept) 
  end 
  
  def self.add_refs_data_object(parameters)
    data_object = DataObject.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    references = parameters[:references]
    add_refs(data_object, references)
  end
  
  # how node site handle update data object action after pull
  def self.update_data_object(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    data_object = DataObject.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    #references = parameters[:references]
    commit_link = parameters[:commit_link]
    new_revision_origin_id = parameters[:new_revision_origin_id]
    new_revision_site_id = parameters[:new_revision_site_id]
    toc_id = nil
    if parameters[:toc_site_id]
      toc = TocItem.where("site_id = ? and origin_id = ?", parameters[:toc_site_id], parameters[:toc_id]).first
      toc_id = toc.id if toc
    end
    link_type_id = nil
    if parameters[:link_type_site_id]
      link_type = LinkType.find("site_id = ? and origin_id = ?", parameters[:link_type_site_id], parameters[:link_type_id]).first
      link_type_id = link_type.id  if link_type
    end
    
    parameters = parameters.reverse_merge(origin_id: parameters[:sync_object_id],
                                          site_id: parameters[:sync_object_site_id]) 
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                       :action_taken_at, :language , :commit_link,
                                       :taxon_concept_origin_id, :taxon_concept_site_id,
                                       :references, :link_type_id, :toc_id, :toc_site_id,
                                       :link_type_site_id, :new_revision_origin_id,
                                       :new_revision_site_id],parameters)                                                          
    
    new_data_object = data_object.replicate(parameters, user: user, toc_id: toc_id,
                                             link_type_id: link_type_id, link_object: commit_link)
    # add sync ids
    new_data_object[:origin_id] = new_revision_origin_id
    new_data_object[:site_id] = new_revision_site_id
    new_data_object.save                                        
    user.log_activity(:updated_data_object_id, value: new_data_object.id,
                                taxon_concept_id: new_data_object.taxon_concept_for_users_text.id)                                             
  end
 
  def self.rate_data_object(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    data_object = DataObject.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    stars = parameters[:stars]
    rated_successfully = data_object.rate(user, stars.to_i)
    user.log_activity(:rated_data_object_id, value: data_object.id)
    data_object.update_solr_index if rated_successfully
  end 
 
  def self.get_url(base_url, cache_url,file_type)
    file_type = "jpg" if file_type == "jpeg"
    file_url = "#{cache_url[0,4]}\/#{cache_url[4,2]}\/#{cache_url[6,2]}\/#{cache_url[8,2]}\/#{cache_url[10,5]}.#{file_type}"
    return base_url + file_url
  end
  
  
  def self.create_common_name(parameters)
    taxon_concept = TaxonConcept.find_by_site_id_and_origin_id(parameters[:taxon_concept_site_id], parameters[:taxon_concept_origin_id])
    if taxon_concept 
      user = User.find_site_specific(parameters[:user_site_object_id],parameters[:user_site_id])
      taxon_concept.add_common_name_synonym(parameters[:string], agent: user.agent,
                                            language: parameters[:language],
                                            vetted: Vetted.trusted,
                                            site_id: parameters[:name_site_id],
                                            name_origin_id: parameters[:name_origin_id],
                                            synonym_site_id: parameters[:sync_object_site_id],
                                            synonym_origin_id: parameters[:sync_object_id])
      taxon_concept.reindex_in_solr
    end
  end
 
  def self.delete_common_name(parameters)
    synonym = Synonym.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    if synonym && taxon_concept
      tcn = TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(synonym.id, taxon_concept.id)
      taxon_concept.delete_common_name(tcn)
      taxon_concept.reindex_in_solr
    end
  end
 
  def self.vet_common_name(parameters)
    language_id = parameters[:language].id
    name_id = Name.find_by_string(parameters[:string]).id
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    vetted = Vetted.find_or_create_by_view_order(parameters[:vetted_view_order])
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    found = taxon_concept.vet_common_name(language_id: language_id, name_id: name_id, vetted: vetted, user: user,
                                        date: parameters[:action_taken_at])
    if found
      user.log_activity(:vetted_common_name, taxon_concept_id: taxon_concept.id, value: name_id)
      taxon_concept.reindex_in_solr
    end
  end
 
  def self.update_common_name(parameters)
    name = Name.find_by_string(parameters[:string])
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    language = parameters[:language]
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    taxon_concept.add_common_name_synonym(name.string,
                                          agent: user.agent,
                                          language: language,
                                          preferred: 1,
                                          vetted: Vetted.trusted,
                                          site_id: name.site_id,
                                          date: parameters[:action_taken_at],
                                          is_preferred: parameters[:is_preferred])
    user.log_activity(:updated_common_names, taxon_concept_id: taxon_concept.id)
  end
  
  def self.create_content_page(parameters)
    if(parameters[:parent_content_page_origin_id] != nil && parameters[:parent_content_page_site_id != nil])
      parent_content_page = ContentPage.find_site_specific(parameters[:parent_content_page_origin_id], parameters[:parent_content_page_site_id])
      parent_content_page_id = parent_content_page.id
    else
      parent_content_page_id = nil  
    end
    local_content_page = ContentPage.find_by_page_name(parameters[:page_name])
    if local_content_page.nil? || local_content_page.older_than?(parameters[:created_at], "created_at")
      content_page = ContentPage.new(parent_content_page_id: parent_content_page_id,
                                     page_name: parameters[:page_name], active: parameters[:active],
                                     sort_order: parameters[:sort_order], origin_id: parameters[:sync_object_id],
                                     site_id: parameters[:sync_object_site_id],
                                     created_at: parameters[:created_at])
                                     
      content_page.translations.build(language_id: parameters[:language].id,
                           title: parameters[:title], main_content: parameters[:main_content],
                           left_content: parameters[:left_content], 
                           meta_keywords: parameters[:meta_keywords],
                           meta_description: parameters[:meta_description],
                           active_translation: parameters[:active_translation])
      content_page.save
      user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
      content_page.update_attributes(last_update_user_id: user.id) unless content_page.nil?
    end
  end
  
  def self.delete_content_page(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if content_page
      page_name = content_page.page_name
      content_page.last_update_user_id = user.id
      parent_content_page_id = content_page.parent_content_page_id
      sort_order = content_page.sort_order
      content_page.destroy
      ContentPage.update_sort_order_based_on_deleting_page(parent_content_page_id, sort_order)
    end
  end
  
  def self.swap_content_page(parameters)
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if content_page
      if content_page.older_than?(parameters[:updated_at], "swap_updated_at")
        content_page.update_column(:sort_order, parameters[:content_page_sort_order])
        content_page.update_column(:swap_updated_at, parameters[:updated_at])
      end
    end
  end
  
  def self.update_content_page(parameters)
    if(parameters[:parent_content_page_origin_id] != nil && parameters[:parent_content_page_site_id != nil])
      parent_content_page = ContentPage.find_site_specific(parameters[:parent_content_page_origin_id], parameters[:parent_content_page_site_id])
      parent_content_page_id = parent_content_page.id
    else
      parent_content_page_id = nil  
    end
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if content_page
      if content_page.older_than?(parameters[:updated_at], "updated_at")
        content_page.update_attributes(parent_content_page_id: parameters[:parent_content_page_id],
                                       page_name: parameters[:page_name], active: parameters[:active],
                                       updated_at: parameters[:updated_at] )      
      end
    end
  end
  
  def self.add_translation_content_page(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language],parameters)
    if content_page
      local_translated_content_page = TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, parameters[:language_id])
      if local_translated_content_page.nil? || local_translated_content_page.older_than?(parameters[:created_at], "created_at")
        translated_content_page = content_page.translations.build(parameters)
        content_page.last_update_user_id = user.id
        content_page.save
      end
    end
  end
  
  def self.update_translated_content_page(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    translated_content_page = TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, parameters[:language_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language, :language_id],parameters)
    older_version = translated_content_page.dup
    if translated_content_page
      if translated_content_page.update_attributes(parameters)
        if translated_content_page.older_than?(parameters[:updated_at], "updated_at")
          if content_page
          content_page.last_update_user_id = user.id
          content_page.save
          end
          archive_fields = older_version.attributes.delete_if{ |k,v| [ 'id', 'active_translation' ].include?(k) }.
            merge(translated_content_page_id: older_version.id, original_creation_date: older_version.created_at)
          TranslatedContentPageArchive.create(archive_fields)
        end
      end 
    end
  end
  
  def self.delete_translated_content_page(parameters)
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    translated_content_page = TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, parameters[:language_id])
    translated_content_page.destroy if translated_content_page
  end
  
  def self.create_community(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    collection = Collection.find_site_specific(parameters[:collection_origin_id], parameters[:collection_site_id])
    community = Community.create(name: parameters[:community_name], 
                                 description: parameters[:community_description], 
                                 origin_id: parameters[:sync_object_id], 
                                 site_id: parameters[:sync_object_site_id])
    
    collection.communities << community if collection    
    community.initialize_as_created_by(user)
    EOL::GlobalStatistics.increment('communities') if community.published?
    #add logo
    download_object_file("Community", community, parameters, "logo")
    options = {user: user, without_flash: true}
    auto_collect_helper(community, options)
    community.collections.each do |focus|
      auto_collect_helper(focus, options)
    end
    opts = {user: user, community: community}
    log_community_action(:create, opts)
  end
  
  def self.add_community(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    collection = Collection.find_site_specific(parameters[:collection_origin_id], parameters[:collection_site_id])
    community = Community.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if collection && community
      collection.communities << community
      opts = {user: user, community: community, collection_id: collection.id}
      log_community_action(:add_collection, opts)
    end
  end
  
  def self.update_community(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    community = Community.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if community
      community.update_column(:name, parameters[:community_name]) if parameters[:name_change]
      community.update_column(:description, parameters[:community_description]) if parameters[:description_change]
      #UPDATE logo
      download_object_file("Community", community, parameters, "logo")
      opts = {user: user, community: community}
      log_community_action(:change_name, opts) if parameters[:name_change] == "1"
      opts = {user: user, community: community}
      log_community_action(:change_description, opts) if parameters[:description_change] == "1"
    end
  end
  
  def self.delete_community(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    community = Community.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if community
      community.update_column(:published, false)
      community.collection.update_column(:published, false) rescue nil
      if user
        community.remove_member(user)
        community.save
      end
      EOL::GlobalStatistics.decrement('communities')
      opts = {user: user, community: community}
      log_community_action(:delete, opts)
    end
  end
  
  def self.join_community(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    community = Community.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if community && user
      member = community.add_member(user)
      options = {}
      options[:user] = user
      options[:annotation] = I18n.t(:user_joined_community_on_date, date: I18n.l(parameters[:action_taken_at]),
      username: user.full_name)
      options[:without_flash] = true
      auto_collect_helper(community, options)
      community.collections.each do |focus|
        auto_collect_helper(focus,options)
      end
      opts = {user: user, community: community, member_id: user.id}
      log_community_action(:join, opts)
    end
  end
  
  def self.leave_community(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    community = Community.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if community && user
      community.remove_member(user)
      opts = {user: user, community: community, member_id: user.id}
      log_community_action(:leave, opts)
    end
  end
  
  def self.save_association_data_object(parameters)
    user = User.find_by_origin_id_and_site_id(parameters[:user_site_object_id], parameters[:user_site_id])
    data_object = DataObject.find_by_origin_id_and_site_id(parameters[:sync_object_id], parameters[:sync_object_site_id])
    he = HierarchyEntry.find_by_origin_id_and_site_id(parameters[:hierarchy_entry_origin_id], parameters[:hierarchy_entry_site_id])
    actual_cdohe = data_object.existing_association(he)
    if actual_cdohe.nil? # there is no exixsting one then create it
      cdohe = data_object.add_curated_association(user, he)
      data_object.update_solr_index
      options = {data_object: data_object, user: user}
      log_data_object_action(cdohe, :add_association, options)
    end
  end
  
  def self.remove_association_data_object(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    data_object = DataObject.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    he = HierarchyEntry.find_site_specific(parameters[:hierarchy_entry_origin_id], parameters[:hierarchy_entry_site_id])
    cdohe = data_object.remove_curated_association(user, he)
    data_object.update_solr_index
    options = {data_object: data_object, user: user}
    log_data_object_action(cdohe, :remove_association, options)
  end
  
  def self.curate_associations_data_object(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    data_object = DataObject.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    visibility = parameters[:visibility_label] ? Visibility.find(TranslatedVisibility.find_by_language_id_and_label(parameters[:language].id, parameters[:visibility_label]).visibility_id) : nil
    untrust_reasons = parameters[:untrust_reasons] ? get_objects_ids(parameters[:untrust_reasons], "UntrustReason") : nil
    hide_reasons = parameters[:hide_reasons] ? get_objects_ids(parameters[:hide_reasons], "UntrustReason"): nil
    comment = (parameters[:curation_comment_origin_id] && parameters[:curation_comment_site_id]) ? Comment.find_by_origin_id_and_site_id(parameters[:curation_comment_origin_id], parameters[:curation_comment_site_id]) : nil
    # check if this is old or new update
    he = HierarchyEntry.find_by_origin_id_and_site_id(parameters[:hierarchy_entry_origin_id], parameters[:hierarchy_entry_site_id])
    assoc = CuratedDataObjectsHierarchyEntry.find_by_data_object_guid_and_hierarchy_entry_id(data_object.guid, he.id)
    assoc = DataObjectsHierarchyEntry.find_by_data_object_id_and_hierarchy_entry_id(data_object.id, he.id) if assoc.nil?
    # if it is newer take it else keep the old one
    if assoc.older_than?(parameters[:action_taken_at], "updated_at")
      association = data_object.data_object_taxa.find {|item| item.taxon_concept.origin_id == taxon_concept.origin_id && item.taxon_concept.site_id == taxon_concept.site_id}
      if association
        curation = Curation.new(
            association: association,
            user: user,
            vetted: Vetted.find_by_view_order(parameters[:vetted_view_order]),
            visibility: visibility,
            comment: comment, 
            untrust_reason_ids: untrust_reasons,
            hide_reason_ids: hide_reasons)
        curation.curate
        DataObjectCaching.clear(data_object)
        options = {user: user, without_flash: true}
        auto_collect_helper(data_object, options) 
        data_object.reindex
      end
    end
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
  
  def self.create_search_suggestion(parameters)
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    parameters[:taxon_id] = taxon_concept.id
    parameters[:origin_id] = parameters[:sync_object_id]
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:created_at] = parameters[:action_taken_at]
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language, :taxon_concept_origin_id, :taxon_concept_site_id],parameters)
    SearchSuggestion.create(parameters)
  end
  
  def self.update_search_suggestion(parameters)
    taxon_concept = TaxonConcept.find_site_specific(parameters[:taxon_concept_origin_id], parameters[:taxon_concept_site_id])
    parameters[:taxon_id] = taxon_concept.id
    updated_at = parameters[:action_taken_at]
    parameters[:updated_at] = parameters[:action_taken_at]
    search_suggestion = SearchSuggestion.find_by_origin_id_and_site_id(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if search_suggestion.older_than?(parameters[:action_taken_at], "updated_at")
      parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                :action_taken_at, :language, :taxon_concept_origin_id, :taxon_concept_site_id],parameters)
      search_suggestion.update_attributes(parameters)
    end
  end
  
  def self.create_glossary_term(parameters)
    # duplicate term then keep last
    duplicate_term = GlossaryTerm.find_by_term(parameters[:term]) 
    if duplicate_term.nil? || (duplicate_term && parameters[:action_taken_at] > duplicate_term.created_at)
      duplicate_term.destroy if duplicate_term
      parameters[:origin_id] = parameters[:sync_object_id]
      parameters[:site_id] = parameters[:sync_object_site_id]
      parameters[:created_at] = parameters[:action_taken_at]
      parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                :action_taken_at, :language],parameters)
      GlossaryTerm.create(parameters)
    end
  end
  
  def self.hide_user(parameters)
    user = User.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    admin = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    user.update_column(:hidden, 1)
    user.hide_comments(admin)
    user.hide_data_objects
  end
  
  def self.show_user(parameters)
    user = User.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    admin = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    user.update_column(:hidden, 0)
    user.unhide_comments(admin)
    user.unhide_data_objects
  end
  
  def self.create_agreement(parameters)
    # TODO upload file
    parameters[:origin_id] = parameters[:sync_object_id]
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:created_at] = parameters[:action_taken_at]
    partner = ContentPartner.find_site_specific(parameters[:partner_origin_id], parameters[:partner_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language, :partner_origin_id, :partner_site_id],parameters)
    agreement = partner.content_partner_agreements.build(parameters)
    agreement.save
  end
  
  def self.update_agreement(parameters)
    # TODO upload file
    agreement = ContentPartnerAgreement.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    parameters[:updated_at] = parameters[:action_taken_at]
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language, :partner_origin_id, :partner_site_id],parameters)
    agreement.update_attributes(parameters)
  end
  
  def self.create_content_upload(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_upload = ContentUpload.create!(description: parameters[:description],
                                           link_name: parameters[:link_name],
                                           created_at: parameters[:action_taken_at],
                                           origin_id: parameters[:sync_object_id],
                                           site_id: parameters[:sync_object_site_id])
    content_upload.update_attributes(user_id: user.id)
    base_url = parameters[:base_url]
    parameters[:is_file] = true
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language],parameters)
    download_object_file("content_upload", content_upload, parameters, "file")
  end
  
  def self.update_content_upload(parameters)
    content_upload = ContentUpload.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    content_upload.update_attributes(description: parameters[:description],
                                     link_name: parameters[:link_name],)
  end
  
  # content_partner_contacts
  def self.create_contact(parameters)
    parameters[:origin_id] = parameters[:sync_object_id]
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:created_at] = parameters[:action_taken_at]
    partner = ContentPartner.find_site_specific(parameters[:partner_origin_id],
                parameters[:partner_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, 
                              :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language, :partner_origin_id, 
                              :partner_site_id],parameters)
    contact = partner.content_partner_contacts.build(parameters)
    contact.save
  end
  
  def self.update_contact(parameters)
    parameters[:updated_at] = parameters[:action_taken_at]
    contact = ContentPartnerContact.find_by_origin_id_and_site_id(
                parameters[:sync_object_id], parameters[:sync_object_site_id])
    if contact.older_than?(parameters[:action_taken_at], "updated_at")
      parameters = delete_keys([:user_site_id, :user_site_object_id, 
                     :sync_object_site_id, :sync_object_id, :action_taken_at, 
                     :language],parameters)
      contact.update_attributes(parameters)
    end
  end
  
  def self.delete_contact(parameters)
    partner = ContentPartner.find_site_specific(parameters[:partner_origin_id],
                parameters[:partner_site_id])
    contact = ContentPartnerContact.find_by_origin_id_and_site_id(
                parameters[:sync_object_id], parameters[:sync_object_site_id])
    if !partner.nil? && !contact.nil?
      partner.content_partner_contacts.delete(contact)
    end
  end
  
  # news_item
  def self.create_news_item(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], 
                                   parameters[:user_site_id])
    news_item = NewsItem.new("page_name" => parameters[:"page_name"], 
                             "display_date(3i)" => parameters[:"display_date(3i)"],
                             "display_date(2i)" => parameters[:"display_date(2i)"],
                             "display_date(1i)" => parameters[:"display_date(1i)"],
                             "display_date(4i)" => parameters[:"display_date(4i)"],
                             "display_date(5i)" => parameters[:"display_date(5i)"],
                             "activated_on(3i)" => parameters[:"activated_on(3i)"],
                             "activated_on(2i)" => parameters[:"activated_on(2i)"],
                             "activated_on(1i)" => parameters[:"activated_on(1i)"],
                             "activated_on(4i)" => parameters[:"activated_on(4i)"],
                             "activated_on(5i)" => parameters[:"activated_on(5i)"],
                             "active" => parameters[:"active"],
                             "origin_id" => parameters[:sync_object_id],
                             "site_id" => parameters[:sync_object_site_id])
    news_item.translations.build(language_id: parameters[:language_id], 
                                 title: parameters[:title], 
                                 body: parameters[:body], 
                                 active_translation: parameters[:active_translation])
    news_item.last_update_user_id = user.id 
    if news_item.save
      news_item.update_attributes(created_at: parameters[:action_taken_at],
        updated_at: parameters[:action_taken_at])
    end 
  end
  
  def self.update_news_item(parameters)
    news_item = NewsItem.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    # check for existance as it may be deleted
    if news_item && news_item.older_than?(parameters[:action_taken_at], "updated_at")
      news_item.update_attributes("page_name" => parameters[:page_name], 
                                  "display_date(3i)" => parameters[:"display_date(3i)"],
                                  "display_date(2i)" => parameters[:"display_date(2i)"],
                                  "display_date(1i)" => parameters[:"display_date(1i)"],
                                  "display_date(4i)" => parameters[:"display_date(4i)"],
                                  "display_date(5i)" => parameters[:"display_date(5i)"],
                                  "activated_on(3i)" => parameters[:"activated_on(3i)"],
                                  "activated_on(2i)" => parameters[:"activated_on(2i)"],
                                  "activated_on(1i)" => parameters[:"activated_on(1i)"],
                                  "activated_on(4i)" => parameters[:"activated_on(4i)"],
                                  "activated_on(5i)" => parameters[:"activated_on(5i)"],
                                  "active" => parameters[:active],
                                  "updated_at" => parameters[:action_taken_at])
    end
  end
  
  def self.delete_news_item(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], 
                                   parameters[:user_site_id])
    news_item = NewsItem.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    news_item = NewsItem.find(news_item.id, include: [:translations])
    # check for existance as it may be deleted
    if news_item
      news_item.last_update_user_id = user.id
      news_item.destroy
    end
  end
  
  # translated_news_item
  def self.create_translated_news_item(parameters)
    news_item = NewsItem.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    user = User.find_site_specific(parameters[:user_site_object_id], 
                                   parameters[:user_site_id])
    existing_translated_news = TranslatedNewsItem.find_by_language_id_and_news_item_id(
      parameters[:"language_id"], news_item.id)
    if existing_translated_news.nil? ||
      (!existing_translated_news.nil? && 
        existing_translated_news.older_than?(parameters[:action_taken_at], "created_at"))
      existing_translated_news.destroy if !existing_translated_news.nil? 
      news_item.translations.build(language_id: parameters[:language_id], 
                                   title: parameters[:title], 
                                   body: parameters[:body], 
                                   active_translation: parameters[:active_translation])
      news_item.last_update_user_id = user.id
      if news_item.save
        news_item.translations.find_by_language_id(parameters[:language_id]).
        update_attributes(created_at: parameters[:action_taken_at],
          updated_at: parameters[:action_taken_at])
      end 
    end
  end
  
  def self.update_translated_news_item(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], 
                                   parameters[:user_site_id])
    news_item = NewsItem.find_site_specific(parameters[:sync_object_id],
                                            parameters[:sync_object_site_id])
    # check for existance as it may be deleted
    if news_item
      news_item = NewsItem.find(news_item.id, include: [:translations])
      translated_news_item = TranslatedNewsItem.find_by_language_id_and_news_item_id(
      parameters[:language_id], news_item.id)
      # check for existance as it may be deleted
      if translated_news_item && translated_news_item.older_than?(parameters[:action_taken_at], 
                                                                  "updated_at")
        translated_news_item.update_attributes(language_id: parameters[:language_id], 
                                               title: parameters[:title], 
                                               body: parameters[:body], 
                                               active_translation: parameters[:active_translation],
                                               updated_at: parameters[:action_taken_at])
        news_item.last_update_user_id = user.id
        news_item.updated_at = parameters[:action_taken_at]
        news_item.save
      end
    end
  end
  
  def self.delete_translated_news_item(parameters)
    news_item = NewsItem.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    # check for existance as it may be deleted
    if news_item
      translated_news_item = TranslatedNewsItem.find_by_language_id_and_news_item_id(
        parameters[:language_id], news_item.id)
      # check for existance as it may be deleted
      if translated_news_item
        translated_news_item.destroy
      end
    end
  end
  
  # Forum
  def self.create_forum(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    forum_category = ForumCategory.find_site_specific(parameters[:forum_category_origin_id], 
                                                      parameters[:forum_category_site_id])
    forum = Forum.create(forum_category_id: forum_category.id, 
                         name: parameters[:name], description: parameters[:description],
                         user_id: user.id, site_id: parameters[:sync_object_site_id],
                         origin_id: parameters[:sync_object_id], 
                         created_at: parameters[:action_taken_at])
  end
  
  def self.update_forum(parameters)
    
    forum = Forum.find_site_specific(parameters[:sync_object_id], 
                                     parameters[:sync_object_site_id])
    forum_category = ForumCategory.find_site_specific(parameters[:forum_category_origin_id], 
                                                      parameters[:forum_category_site_id])
    if forum
      if forum.older_than?(parameters[:updated_at], "updated_at")
        forum.update_attributes(forum_category_id: forum_category.id, 
                                name: parameters[:name], description: parameters[:description],
                                site_id: parameters[:sync_object_site_id],
                                origin_id: parameters[:sync_object_id], 
                                updated_at: parameters[:updated_at])
      end
    end
  end
  
  def self.delete_forum(parameters)
    forum = Forum.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    forum.destroy if forum
  end
  
  def self.swap_forum(parameters)
   forum = Forum.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if forum
      if forum.older_than?(parameters[:updated_at], "swap_updated_at")
        forum.update_attributes(view_order: parameters[:forum_sort_order],
                                swap_updated_at: parameters[:updated_at])
      end
    end
  end
  
  #posts
  def self.create_post(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    topic = ForumTopic.find_site_specific(parameters[:topic_origin_id], 
                                          parameters[:topic_site_id])
    parent_post = ForumPost.find_site_specific(parameters[:parent_post_origin_id], parameters[:parent_post_site_id]) if parameters[:parent_post_origin_id]
    parent_post_id = parent_post.nil? ? nil : parent_post.id
    ForumPost.create(forum_topic_id: topic.id, subject: parameters[:subject],
                     text: parameters[:text], user_id: user.id, site_id: parameters[:sync_object_site_id],
                     origin_id: parameters[:sync_object_id], created_at: parameters[:action_taken_at],
                     reply_to_post_id: parent_post_id, edit_count: parameters[:edit_count])
  end
  
  def self.update_post(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    post = ForumPost.find_site_specific(parameters[:sync_object_id], 
                                          parameters[:sync_object_site_id])
    if post
      if post.older_than?(parameters[:updated_at], "updated_at")
        post.update_attributes(subject: parameters[:subject], text: parameters[:text],
                               updated_at: parameters[:updated_at],
                               edit_count: parameters[:edit_count])
      end
    end
  end
  
  def self.delete_post(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    post = ForumPost.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    topic = ForumTopic.find_site_specific(parameters[:topic_origin_id], parameters[:topic_site_id])
    if post
      post.update_attributes({ deleted_at: parameters[:post_deleted_at], deleted_by_user_id: user.id,
                               edit_count: parameters[:edit_count] })
      topic.update_attributes({ deleted_at: parameters[:topic_deleted_at], deleted_by_user_id: user.id }) if topic
    end
  end
  
  # forum topic
  def self.create_topic(parameters)
    forum = Forum.find_site_specific(parameters[:forum_origin_id], 
              parameters[:forum_site_id])
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    if forum
      topic_data = { forum_id: forum.id, 
                     forum_posts_attributes: { "0" => { subject: parameters[:subject], 
                                                        text: parameters[:text] } } }
      topic_data[:title] = topic_data[:forum_posts_attributes]["0"][:subject]
      topic_data[:user_id] = user.id
      topic_data[:forum_posts_attributes]["0"][:user_id] = user.id
      topic = ForumTopic.new(topic_data)
      if topic.save
        topic.reload
        topic.update_attributes(origin_id: parameters[:sync_object_id], 
          site_id: parameters[:sync_object_site_id],
            created_at: parameters[:action_taken_at], updated_at: parameters[:action_taken_at])
        first_post = topic.first_post
        first_post.update_attributes(origin_id: parameters[:first_post_origin_id], 
          site_id: parameters[:first_post_site_id], created_at: parameters[:action_taken_at], 
            updated_at: parameters[:action_taken_at])  
      end
    end
  end
  
  def self.delete_topic(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    topic = ForumTopic.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if topic.forum_posts.visible.count == 0
      topic.update_attributes({ deleted_at: parameters[:action_taken_at], deleted_by_user_id: user.id }) 
    end
  end  
  
  # Forum Categories
  def self.create_category(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    category = ForumCategory.create(title: parameters[:title], description: parameters[:description])
    category.update_attributes(origin_id: parameters[:sync_object_id], 
      site_id: parameters[:sync_object_site_id], user_id: user.id, 
        created_at: parameters[:action_taken_at], updated_at: parameters[:action_taken_at])
  end
  
  def self.update_category(parameters)
    category = ForumCategory.find_site_specific(parameters[:sync_object_id], 
      parameters[:sync_object_site_id])
    if category && category.older_than?(parameters[:action_taken_at], "updated_at")
      category.update_attributes(title: parameters[:title], description: parameters[:description], 
        updated_at: parameters[:action_taken_at])
    end
  end
  
  def self.delete_category(parameters)
    category = ForumCategory.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    category.destroy if category
  end
  
  #content_partner
  def self.update_content_partner(parameters)
    user = User.find_site_specific(parameters[:partner_user_origin_id], parameters[:partner_user_site_id])
    object_logo_parameters = {logo_cache_url: parameters[:logo_cache_url],
                              logo_file_name: parameters[:logo_file_name],
                              logo_content_type: parameters[:logo_content_type],
                              logo_file_size: parameters[:logo_file_size]}
    base_url = parameters[:base_url]
    action_taken_at = parameters[:action_taken_at]
    partner = ContentPartner.find_site_specific(parameters[:sync_object_id], 
      parameters[:sync_object_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :base_url, :logo_cache_url, 
                              :logo_file_name, :logo_content_type, :logo_file_size, :language,
                              :partner_user_origin_id, :partner_user_site_id],parameters)
    if partner && partner.older_than?(action_taken_at, "updated_at")
      partner.update_attributes(parameters)
      partner.update_attributes(user_id: user.id)
      object_logo_parameters[:base_url] = base_url
      download_object_file("ContentPartner", partner, object_logo_parameters, "logo")
    end
  end
  
  # Resources
  def self.create_resource(parameters)
    port = parameters[:port]
    partner = ContentPartner.find_site_specific(parameters[:partner_origin_id], 
      parameters[:partner_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                             :action_taken_at, :base_url, :logo_cache_url, 
                             :logo_file_name, :logo_content_type, :logo_file_size,
                             :partner_origin_id, :partner_site_id, :port],parameters)
    resource = partner.resources.build(parameters)
    if resource.save
      resource.upload_resource_to_content_master!(port)
    end
  end
  
  def self.update_resource(parameters)
    port = parameters[:port]
    resource = Resource.find_site_specific(:sync_object_id, sync_object_site_id)
    
    if parameters[:commit_update_settings_only]
      upload_required = false
    else
      existing_dataset_file_size = resource.dataset_file_size
      # we need to check the accesspoint URL before saving the updated resource
      upload_required = (resource.accesspoint_url != parameters[:accesspoint_url] || !parameters[:dataset].blank?)
    end
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :base_url, :logo_cache_url, 
                              :logo_file_name, :logo_content_type, :logo_file_size,
                              :port, :commit_update_settings_only],parameters)
    if resource.update_attributes(parameters)
      if upload_required
        resource.upload_resource_to_content_master!(port)
      end
    end
  end
  
  #search_log
  def self.create_search_log(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    SearchLog.create(search_term: parameters[:search_term], 
                     search_type: parameters[:search_type],
                     total_number_of_results: parameters[:total_number_of_results],
                     ip_address_raw: parameters[:ip_address_raw], 
                     user_agent: parameters[:user_agent], 
                     path: parameters[:path],
                     user_id: user.id, 
                     site_id: parameters[:sync_object_site_id],
                     origin_id: parameters[:sync_object_id],
                     created_at: parameters[:action_taken_at]) 
  end
  
  #known uris
  def self.create_known_uri(parameters)
    local_known_uri = KnownUri.where("uri = ? ", parameters[:uri]).first
    if local_known_uri.nil? || local_known_uri.older_than?(parameters[:created_at], "created_at")
      local_known_uri.destroy if local_known_uri
      parameters[:site_id] = parameters[:sync_object_site_id]
      parameters[:origin_id] = parameters[:sync_object_id] 
      parameters[:toc_item_ids] = get_toc_ids(parameters[:toc_sync_ids]) if parameters[:toc_sync_ids]
      
      translated_known_uris_attributes = { "0" =>  { name: parameters[:name], 
                                           language_id: parameters[:language_id],
                                           definition: parameters[:definition],
                                           comment: parameters[:comment],
                                           attribution: parameters[:attribution] } }
      parameters[:translated_known_uris_attributes] = translated_known_uris_attributes
      parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, 
                                :sync_object_id, :action_taken_at, :language, :name, 
                                :comment, :language_id, :definition,
                                :attribution, :toc_sync_ids],parameters)
      KnownUri.create(parameters)
    end
  end
  
  def self.get_toc_ids(tocs_sync_ids)
    tocs_ids = []
    tocs_sync_ids.split.each do |toc_sync_ids|
      if toc_sync_ids
        sync_ids = toc_sync_ids.split(",") 
        toc_item = TocItem.find_site_specific(sync_ids[0].to_i, sync_ids[1].to_i)
        tocs_ids << toc_item.id.to_s if toc_item
      end
    end
    tocs_ids
  end
end
