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
    keys.each { |key| hash.delete key}
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
    
    user = User.create(parameters)
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
    parameters[:user_identity_ids] = parameters[:user_identity_ids].split(",")  if parameters[:user_identity_ids]
    parameters[:site_id] = parameters[:sync_object_site_id]
    parameters[:origin_id] = parameters[:sync_object_id]
    base_url = parameters[:base_url]
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                       :action_taken_at, :base_url],parameters)
                                       
    user = User.find_site_specific(parameters[:origin_id], parameters[:site_id])
    if user
      user.update_attributes(parameters)
      # call log activity
      user.log_activity(:updated_user)
      
      parameters[:base_url] = base_url
      download_object_logo("User", user, parameters)
   end
  end
  
  def self.download_object_logo(object_type, object, parameters)
    logo_file_name = parameters[:logo_file_name]
    if logo_file_name
      base_url = parameters[:base_url]
      logo_cache_url = parameters[:logo_cache_url]
      directory_name = object_type.downcase.pluralize
      file_type = logo_file_name[logo_file_name.rindex(".") + 1 , logo_file_name.length ]
      logo_name = "#{directory_name}_#{object.id}.#{file_type}"
      file_url = self.get_url(base_url, logo_cache_url,file_type)
      if download_file?(file_url, logo_name, "logo")   
        delete_logo(object, directory_name, file_type)
        
        # update logo parameters
        object.update_column(:logo_file_name, logo_name)
        object.update_column(:logo_content_type, parameters[:logo_content_type])
        object.update_column(:logo_file_size, parameters[:logo_file_size])
        
        upload_object_logo(object)
      else
        log_failed_download(file_url, logo_name, "logo", object_type, object, parameters)
      end
    end
  end
  
  def self.upload_object_logo(object)
    upload_file(object)
  end
  
  def self.delete_logo(object, directory_name, file_type)
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
    collection_owner = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    collection = Collection.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if collection
      if collection.updated_at < parameters[:updated_at]
        parameters[:site_id] = parameters[:sync_object_site_id]
        parameters[:origin_id] = parameters[:sync_object_id] 
        base_url = parameters[:base_url]  
        # remove extra parameters which not needed in creating collection
        parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                                         :action_taken_at, :language , :updated_at, :base_url],parameters)
        if collection
          collection.update_attributes(parameters)
          name_changed = parameters[:name] != collection.name
          description_changed = parameters[:description] != collection.description
          # log create collection action
          CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_name }) if name_changed
          CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_description }) if description_changed
           
          parameters[:base_url] = base_url
          download_object_logo("Collection", collection, parameters)        
        end
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
               dummy_type_id, "unique_job_id", unique_job_id)
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
         if collection_job
           collection_job.run
         end
      end
    end
  end
  
  def self.get_collection_items_ids(peer_logs, origin_col)
    collected_items_ids = []
    peer_logs.each do |peer_log|
      item_type_action_parameter = SyncLogActionParameter.where("peer_log_id = ? and parameter = ? ", peer_log.id, "collected_item_type").first
      item_type = item_type_action_parameter.value if item_type_action_parameter
      item_origin_id_action_parameter = SyncLogActionParameter.where("peer_log_id = ? and parameter = ? ", peer_log.id, "item_id").first
      item_origin_id = item_origin_id_action_parameter.value if item_origin_id_action_parameter
      item_site_id_action_parameter = SyncLogActionParameter.where("peer_log_id = ? and parameter = ? ", peer_log.id, "item_site_id").first
      item_site_id = item_site_id_action_parameter.value if item_site_id_action_parameter
      item = item_type.constantize.find_site_specific(item_origin_id, item_site_id)
      collected_item = CollectionItem.where("collection_id = ? and collected_item_id = ?", origin_col.id, item.id).first
      collected_items_ids << collected_item.id if collected_item
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
      if comment.last_updated_at.nil? || comment.last_updated_at < parameters[:updated_at] 
        parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_id, :sync_object_site_id, 
                                           :action_taken_at, :language],parameters)
        comment.update_attributes(parameters)
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
        Rails.cache.delete('homepage/activity_logs_expiration') if Rails.cache
      end
    end    
  end 
  
  # how node site handle show comment action
  def self.show_comment(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    comment = Comment.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    if user
      if comment
        if (comment.visible_at.nil? || (comment.visible_at < parameters[:visible_at]))
          comment.show(user)
          comment.update_attributes(visible_at: parameters[:visible_at])
          Rails.cache.delete('homepage/activity_logs_expiration') if Rails.cache
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
      if col_item.updated_at < parameters[:updated_at]
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
    parent_content_page = ContentPage.find_site_specific(parameters[:parent_content_page_origin_id], parameters[:parent_content_page_site_id])
    content_page = ContentPage.new(parent_content_page_id: parent_content_page.id,
                                   page_name: parameters[:page_name], active: parameters[:active],
                                   sort_order: parameters[:sort_order])
                                   
    content_page.translations.build(language_id: parameters[:language].id,
                         title: parameters[:title], main_content: parameters[:main_content],
                         left_content: parameters[:left_content], 
                         meta_keywords: parameters[:meta_keywords],
                         meta_description: parameters[:meta_description],
                         active_translation: parameters[:active_translation])
    content_page.save
    content_page.update_column(:origin_id, parameters[:sync_object_id])
    content_page.update_column(:site_id, parameters[:sync_object_site_id])
    
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_page.last_update_user_id = user.id unless content_page.blank?
  end
  
  def self.delete_content_page(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id], include: [:translations, :children])
    page_name = content_page.page_name
    content_page.last_update_user_id = user.id
    parent_content_page_id = content_page.parent_content_page_id
    sort_order = content_page.sort_order
    content_page.destroy
    ContentPage.update_sort_order_based_on_deleting_page(parent_content_page_id, sort_order)
  end
  
  def self.swap_content_page(parameters)
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    swap_page = ContentPage.find_site_specific(parameters[:swap_page_origin_id], parameters[:swap_page_site_id])
    content_page.update_column(:sort_order, parameters[:content_page_sort_order]) if content_page
    swap_page.update_column(:sort_order, parameters[:swap_page_sort_order]) if swap_page
  end
  
  def self.update_content_page(parameters)
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    content_page.update_attributes(parent_content_page_id: parameters[:parent_content_page_id],
                                   page_name: parameters[:page_name], active: parameters[:active])
  end
  
  def self.add_translation_content_page(parameters)
    user = User.find_site_specific(parameters[:user_site_object_id], parameters[:user_site_id])
    content_page = ContentPage.find_site_specific(parameters[:sync_object_id], parameters[:sync_object_site_id])
    parameters = delete_keys([:user_site_id, :user_site_object_id, :sync_object_site_id, :sync_object_id,
                              :action_taken_at, :language],parameters)
    if content_page
      translated_content_page = content_page.translations.build(parameters)
      content_page.last_update_user_id = user.id
      content_page.save
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
    download_object_logo("Community", community, parameters)
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
      download_object_logo("Community", community, parameters)
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
    last_update = assoc.updated_at
    # if it is newer take it else keep the old one
    if last_update.nil? || parameters[:action_taken_at] > last_update
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
  
end
