class CollectionJobsController < ApplicationController

  before_filter :force_login
  before_filter :create_collection_if_asked
  before_filter :read_collection_job_from_params

  layout 'choose_collect_target'

  def create
    # for synchronization
    collection_items = []
    if @collection_job.all_items      
        @collection_job.collection.items.each do |col_item|
          collection_items << col_item
        end
    else
        collection_items = @collection_job.collection_items
    end
    
    return redirect_to(@collection_job.collection, notice: I18n.t(:error_no_items_selected)) unless
      @collection_job.has_items?
    
    create_collection_if_asked  
    
    unless @collection_job.missing_targets?
      if @collection_job.save
        # TODO - we really want to decide if this is a "big" job and delay it, if so.
        Collection.with_master do
          Collection.uncached { @collection_job.run }
        end
        
        # sync collection jobs (copy items- delete items- move items)
        # prepare sync peer log  
        sync_params = {}       
        new_collection = nil
        copied_collections_origin_ids = ""
        copied_collections_site_ids = ""
        collection_items_origin_ids = ""
        collection_items_site_ids = ""
        collection_items_names = ""
        collection_items_types = ""
        all_collections = []
        
        @collection_job.collections.each do |col|
          unless col.nil? 
            all_collections << col
            if col.name == params[:collection_name]
              new_collection = col              
            else           
              copied_collections_origin_ids += col.origin_id.to_s + ","
              copied_collections_site_ids += col.site_id.to_s + ","                
            end
          end
        end
        
         if new_collection
          params = {}
          new_collection.origin_id = new_collection.id
          new_collection.site_id = PEER_SITE_ID
          new_collection.save
          #sync_params["new_collection_origin_id"] = new_collection.origin_id
          params["name"] = new_collection.name
          options = {"user" => current_user, "object" =>  new_collection, "action_id" => SyncObjectAction.get_create_action.id,
                    "type_id" =>  SyncObjectType.get_collection_type.id, "params" => sync_params} 
          SyncPeerLog.log_action(options)
        end
        
        
         copied_collections_origin_ids += new_collection.origin_id.to_s + "," unless new_collection.nil?
         copied_collections_site_ids += new_collection.site_id.to_s + "," unless new_collection.nil?
       
        
        
        collection_items.each do |collected_item|        
           item = collected_item.collected_item_type.constantize.find(collected_item.collected_item_id)
            collection_items_origin_ids += item.origin_id.to_s + "," unless item.origin_id.nil? || item.origin_id.to_s.nil?
            collection_items_site_ids += item.site_id.to_s + "," unless item.site_id.nil? || item.site_id.to_s.nil?
            collection_items_names += collected_item.name + "," unless collected_item.nil? || collected_item.name.nil?
            collection_items_types += collected_item.collected_item_type + "," unless collected_item.nil? || collected_item.collected_item_type.nil?
        end 
        
       
        
        # sync collection job
        sync_params["command"] = @collection_job.command
        sync_params["item_count"] = @collection_job.item_count
        sync_params["all_items"] = @collection_job.all_items
        sync_params["overwrite"] = @collection_job.overwrite
        sync_params["copied_collections_origin_ids"] = copied_collections_origin_ids
        sync_params["copied_collections_site_ids"] = copied_collections_site_ids 
        sync_params["collection_items_origin_ids"] = collection_items_origin_ids 
        sync_params["collection_items_site_ids"] = collection_items_site_ids
        sync_params["collection_items_names"] = collection_items_names
        sync_params["collection_items_types"] = collection_items_types        
        
        options = {"user" => current_user, "object" =>  @collection_job.collection, "action_id" => SyncObjectAction.get_create_job_action.id,
                    "type_id" =>  SyncObjectType.get_collection_type.id, "params" => sync_params} 
        SyncPeerLog.log_action(options)

        collection_items.each do |collected_item| 
          item = collected_item.collected_item_type.constantize.find(collected_item.collected_item_id)
          params = {}             
               
          if @collection_job.command == "remove"  
            params["item_id"] = item.origin_id   
            params["item_site_id"] = item.site_id 
            params["collected_item_type"] = collected_item.collected_item_type
            options = {"user" => current_user, "object" =>  @collection_job.collection, "action_id" => SyncObjectAction.get_remove_collection_item_action.id,
              "type_id" =>  SyncObjectType.get_collection_type.id, "params" => sync_params}              
             SyncPeerLog.log_action(options)
          elsif @collection_job.command == "copy"
             params["collected_item_name"] = collected_item.name
             params["collected_item_type"] = collected_item.collected_item_type          
             params["item_id"] = item.origin_id
             params["item_site_id"] = item.site_id
             all_collections.each do |col|
               options = {"user" => current_user, "object" =>  col, "action_id" => SyncObjectAction.get_add_item_to_collection_action.id,
              "type_id" =>  SyncObjectType.get_collection_type.id, "params" => sync_params}                              
                SyncPeerLog.log_action(options)
             end
          end
        end
        
        redirect_to job_should_redirect_to, notice: complete_notice
      else
        redirect_to @collection_job.collection # TODO - errors are lost because we redirect rather than render...  fix.
      end
    end
    @collections = current_user.all_non_resource_collections # A little weird, but use the 'create' view to get the targets...
  end

  private

  def force_login
    raise EOL::Exceptions::MustBeLoggedIn unless logged_in?
  end

  def read_collection_job_from_params
    # Convert the sumbit button to a command by looking for each valid command in the 'raw' params:
    CollectionJob::VALID_COMMANDS.each do |command|
      params[:collection_job][:command] = command if params.delete(command)
    end
    # Convert all_items:
    params[:collection_job][:all_items] = true if params[:scope] == 'all_items'
    # TODO - Either remove the "other scopes" (and reduce the complexity of the controller/view) from collections,
    # or handle them here. ie: "All Images", "All Taxa" ... doesn't seem to work ATM, so I say remove it.
    # And add the user as we create the new Job:
    @collection_job = CollectionJob.new(params[:collection_job].reverse_merge(user: current_user))
  end

  def complete_notice
    # NOTE - values for command can be found in CollectionJob::VALID_COMMANDS
    I18n.t("collection_#{@collection_job.command}_complete_with_count",
           count: @collection_job.item_count,
           from: link_to_name(@collection_job.collection),
           to: @collection_job.collections.map { |col| link_to_name(col) }.to_sentence )
  end

  def link_to_name(collection)
    return "ERROR: UNKNOWN COLLECTION" unless collection
    self.class.helpers.link_to(collection.name, collection_path(collection))
  end

  def job_should_redirect_to
    collection = @collection_job.collection
    # If they only copy/moved to ONE collection, take them there:
    collection = @collection_job.collections.first if @collection_job.target_needed? && @collection_job.collections.count == 1
    collection
  end

  def create_collection_if_asked
    if params[:collection_job] && params[:collection_job][:collection_ids] &&
       params[:collection_job][:collection_ids].delete("0") && params[:collection_name]
      collection = Collection.new(name: params[:collection_name])
      if collection.save
        collection.users = [current_user]
        params[:collection_job][:collection_ids] << collection.id
      else
        raise "Critical error creating new collection." # this shouldn't happen unless, say, DB is down.
      end     
    end
  end
end
