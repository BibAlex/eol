class SyncPeerLog < ActiveRecord::Base
  attr_accessible :action_taken_at_time, :sync_event_id, :sync_object_action_id, :sync_object_id, :sync_object_site_id, :sync_object_type_id, :user_site_id, :user_site_object_id
  has_many :sync_log_action_parameter, :foreign_key => 'peer_log_id'
  belongs_to :sync_object_type, :foreign_key => 'sync_object_type_id'
  belongs_to :sync_object_action, :foreign_key => 'sync_object_action_id'

  def self.log_add_user(user, params)
    spl = self.create_sync_peer_log(user.site_id, user.user_origin_id, SyncObjectAction.get_create_action.id, SyncObjectType.get_user_type.id, user.site_id, user.user_origin_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
        unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
          self.create_sync_log_action_parameter(spl.id, key, value)
        end
      end
    end   
  end
  
  def self.log_activate_user(user)
    spl = self.create_sync_peer_log(user.site_id, user.user_origin_id, SyncObjectAction.get_activate_action.id, SyncObjectType.get_user_type.id, user.site_id, user.user_origin_id)
  end
  
  #log create common name
  def self.log_add_common_name(user, name, params)
    spl = self.create_sync_peer_log(user.site_id, user.user_origin_id, SyncObjectAction.get_create_action.id, SyncObjectType.get_common_name_type.id, name.site_id, name.origin_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
        self.create_sync_log_action_parameter(spl.id, key, value)
      end
    end
  end
  
  #log delete common name
  def self.log_delete_common_name(user, synonym, params)
    spl = self.create_sync_peer_log(user.site_id, user.user_origin_id, SyncObjectAction.get_delete_action.id, SyncObjectType.get_common_name_type.id, synonym.site_id, synonym.origin_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
        self.create_sync_log_action_parameter(spl.id, key, value)
      end
    end
  end
  
  #log vet common name
  def self.log_vet_common_name(user, name, params)
    spl = self.create_sync_peer_log(user.site_id, user.user_origin_id, SyncObjectAction.get_vet_action.id, SyncObjectType.get_common_name_type.id, name.site_id, name.origin_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
        self.create_sync_log_action_parameter(spl.id, key, value)
      end
    end
  end
  
  
  def self.log_update_common_name(user, name, params)
    spl = self.create_sync_peer_log(user.site_id, user.user_origin_id, SyncObjectAction.get_update_action.id, SyncObjectType.get_common_name_type.id, name.site_id, name.origin_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
        self.create_sync_log_action_parameter(spl.id, key, value)
      end
    end
  end
  # log update user
  def self.log_update_user(user_id, params)
    spl = create_sync_peer_log(PEER_SITE_ID, user_id, SyncObjectAction.get_update_action.id, SyncObjectType.get_user_type.id, PEER_SITE_ID, user_id)
    # add log action parameters
    if spl
      params.delete("requested_curator_level_id")
      params.delete("requested_curator_at")
      params.each do |key, value| 
        unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
          create_sync_log_action_parameter(spl.id, key, value)
        end
      end
    end   
  end
  
  # log update user by admin
  def self.log_update_user_by_admin(admin_id, user_id, params)
    spl = create_sync_peer_log(PEER_SITE_ID, admin_id, SyncObjectAction.get_update_user_by_admin_action.id, SyncObjectType.get_user_type.id, PEER_SITE_ID, user_id)
    # add log action parameters
    if spl
      params.delete("requested_curator_level_id")
      params.delete("requested_curator_at")
      params.each do |key, value| 
        unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
          create_sync_log_action_parameter(spl.id, key, value)
        end
      end
    end   
  end
  
    # log create collection
  def self.log_create_collection(collection_id, user_id,  params)
    spl = create_sync_peer_log(PEER_SITE_ID, user_id, SyncObjectAction.get_create_action.id, SyncObjectType.get_collection_type.id, PEER_SITE_ID, collection_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
          create_sync_log_action_parameter(spl.id, key, value)
      end
    end   
  end
  
    # log update collection
  def self.log_update_collection(collection_id, user_id,  params)
    spl = create_sync_peer_log(PEER_SITE_ID, user_id, SyncObjectAction.get_update_action.id, SyncObjectType.get_collection_type.id, PEER_SITE_ID, collection_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
          create_sync_log_action_parameter(spl.id, key, value)
      end
    end   
  end
  
  
  
  def process_entry
    # TODO: first we need to detect conflict.
    # considering that NOW we are dealing with add users, which won't cause conflicts,
    # So I am skipping it for now
    
    parameters = {}
    parameters["user_site_id"] = user_site_id
    parameters["user_site_object_id"] = user_site_object_id
    parameters["sync_object_site_id"] = sync_object_site_id
    parameters["sync_object_id"] = sync_object_id
    
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
  
  # def process_entry
    # # TODO: first we need to detect conflict.
    # # considering that NOW we are dealing with add users, which won't cause conflicts,
    # # So I am skipping it for now
#     
    # parameters = {}
    # sync_log_action_parameter.each do |lap|
      # unless lap.param_object_type_id
        # parameters[lap.parameter] = lap.value
      # else
        # # find the object and add it to the hash
        # parameters[lap.parameter] = SyncObjectType.find_by_id(lap.param_object_type_id).object_type.constantize.find_by_object_id_and_object_site_id(lap.param_object_id, lap.param_object_site_id)
      # end
    # end
#     
    # if parameters.blank?
      # # this means that the action depends only on user id and user site id
      # parameters[:user_site_id] = user_site_id
      # parameters[:user_site_object_id] = user_site_object_id
    # end
#     
    # model_name = SyncObjectType.find_by_id(sync_object_type_id).object_type
    # action_name = SyncObjectAction.find_by_id(sync_object_action_id).object_action
    # if parameters[:language]
      # parameters[:language] = Language.find_or_create_by_iso_639_1(parameters[:language])
    # else
      # parameters[:language] = Language.first
    # end
    # model_name.constantize.send(action_name, parameters)
  # end
  
  private
  #for any user action such as (registeration, edit profile, ...)
  # def self.handle_user_actions(user_id, params, sync_object_action_id)
    # spl = SyncPeerLog.new
    # spl.user_site_id = PEER_SITE_ID    
    # spl.user_site_object_id = user_id
    # spl.action_taken_at_time = Time.now
    # spl.sync_object_action_id = sync_object_action_id
    # spl.sync_object_type_id = SyncObjectType.get_user_type.id
    # spl.sync_object_site_id = PEER_SITE_ID
    # spl.sync_object_id = user_id
# 
    # # add log action parameters
    # if spl.save
      # params.each do |key, value| 
        # unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
          # slap = SyncLogActionParameter.new
          # slap.peer_log_id = spl.id
          # slap.parameter = key
          # slap.value = value
          # slap.save
        # end
      # end
    # end
  # end
  
  def self.create_sync_peer_log(user_site_id, user_site_object_id, sync_object_action_id, sync_object_type_id, sync_object_site_id, sync_object_id)
    spl = SyncPeerLog.new
    spl.user_site_id = user_site_id    
    spl.user_site_object_id = user_site_object_id
    spl.action_taken_at_time = Time.now
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
    params["user_origin_id"] = parameters["sync_object_id"]
    params["site_id"] = parameters["sync_object_site_id"]
    
    parameters.each do |key, value| 
      unless 'user_site_id user_site_object_id sync_object_site_id sync_object_id'.include? key
        params[key] = value
      end
    end
    user = User.create(params)
    if user
      EOL::GlobalStatistics.increment('users')  
    end
    
  end
  
   def self.update_user(parameters)
    # find user want to update using user origin id and user origin site id 
    parameters[:user_identity_ids] = parameters["user_identity_ids"].split(",")  if (!(parameters["user_identity_ids"].nil?))
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["user_origin_id"] = parameters["sync_object_id"]
    parameters.delete("user_site_id")
    parameters.delete("user_site_object_id")
    parameters.delete("sync_object_id")
    parameters.delete("sync_object_site_id")
    user = User.find_by_user_origin_id_and_site_id(parameters["user_origin_id"], parameters["site_id"])
    if (!(user.nil?))
      user.update_attributes(parameters)
      # call log activity
      user.log_activity(:updated_user)
    end
  end
  
  # update user by admin
  def self.update_by_admin_user(parameters)
    # find user want to update using user origin id and user origin site id 
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["user_origin_id"] = parameters["sync_object_id"]
    parameters.delete("user_site_id")
    parameters.delete("user_site_object_id")
    parameters.delete("sync_object_id")
    parameters.delete("sync_object_site_id")
    user = User.find_by_user_origin_id_and_site_id(parameters["user_origin_id"], parameters["site_id"])
    if (!(user.nil?))
      user.update_attributes(parameters)    
      user.add_to_index
    end
  end
  
  def self.activate_user(parameters)
    user = User.where(:site_id => parameters["sync_object_site_id"], :user_origin_id => parameters["sync_object_id"])
    if user && user.count > 0
      user = user[0]
      user.update_column(:active, true)
      user.update_column(:validation_code, nil)
    end
  end
  
  # how node site handle create collection action
  def self.create_collection(parameters)
    collection_owner = User.find_by_user_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    # remove extra paramters which not needed in creating collection 
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["collection_origin_id"] = parameters["sync_object_id"]  
    parameters.delete("language")   
    parameters.delete("user_site_id")
    parameters.delete("user_site_object_id")
    parameters.delete("sync_object_id")
    parameters.delete("sync_object_site_id")
    #
    collection = Collection.new(parameters)
    collection.save  
    collection.users = [collection_owner]
    # log create collection action
    CollectionActivityLog.create(collection: collection, user: collection_owner, activity: Activity.create)
  end
  
   # how node site handle update collection action
  def self.update_collection(parameters)
    collection_owner = User.find_by_user_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    collection = Collection.find_by_collection_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    # remove extra paramters which not needed in creating collection
    parameters["site_id"] = parameters["sync_object_site_id"]
    parameters["collection_origin_id"] = parameters["sync_object_id"]      
    parameters.delete("language")   
    parameters.delete("user_site_id")
    parameters.delete("user_site_object_id")
    parameters.delete("sync_object_id")
    parameters.delete("sync_object_site_id")
    #
    
    if(!(collection.nil?))
      name_change = parameters[:name] != collection.name
      description_change = parameters[:description] != collection.description
      collection.update_attributes(parameters)    
      
      # log create collection action
      CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_name }) if name_change
      CollectionActivityLog.create({ collection: collection, user_id: collection_owner.id, activity: Activity.change_description }) if description_change
    end
   end
  
  
  

  def self.create_common_name(parameters)
    taxon_concept = TaxonConcept.where(:site_id => parameters["taxon_concept_site_id"], :origin_id => parameters["taxon_concept_origin_id"])
    if taxon_concept && taxon_concept.count > 0
      taxon_concept = taxon_concept[0]      
      user = User.find_by_user_origin_id_and_site_id(parameters["user_site_object_id"],parameters["user_site_id"])
      taxon_concept.add_common_name_synonym(parameters["string"], agent: user.agent, 
                                            language: parameters["language"], 
                                            vetted: Vetted.trusted, 
                                            site_id: parameters["sync_object_site_id"], 
                                            name_origin_id: parameters["sync_object_id"],
                                            synonym_site_id: parameters["synonym_site_id"],
                                            synonym_origin_id: parameters["synonym_origin_id"])
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
    name_id = Name.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"]).id
    user = User.find_by_user_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    vetted = Vetted.find_or_create_by_view_order(parameters["vetted_view_order"])
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    taxon_concept.vet_common_name(language_id: language_id, name_id: name_id, vetted: vetted, user: user)
    user.log_activity(:vetted_common_name, taxon_concept_id: taxon_concept.id, value: name_id)
    taxon_concept.reindex_in_solr
  end
  
  def self.update_common_name(parameters)
    name = Name.find_by_origin_id_and_site_id(parameters["sync_object_id"], parameters["sync_object_site_id"])
    user = User.find_by_user_origin_id_and_site_id(parameters["user_site_object_id"], parameters["user_site_id"])
    language = parameters["language"]
    taxon_concept = TaxonConcept.find_by_origin_id_and_site_id(parameters["taxon_concept_origin_id"], parameters["taxon_concept_site_id"])
    taxon_concept.add_common_name_synonym(name.string, 
                                          agent: user.agent, 
                                          language: language, 
                                          preferred: 1, 
                                          vetted: Vetted.trusted,
                                          new_flag: true,
                                          site_id: name.site_id)
    user.log_activity(:updated_common_names, taxon_concept_id: taxon_concept.id)
  end
end