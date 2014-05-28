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
        sync_collection_job(collection_items)
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
  
  # synchronization
  
  def sync_collection_job(collection_items)
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
      new_collection.origin_id = new_collection.id
      new_collection.site_id = PEER_SITE_ID
      new_collection.save
      sync_create_collection(new_collection)
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
    # sync create collection job
    sync_create_collection_job(copied_collections_origin_ids, copied_collections_site_ids,
    collection_items_origin_ids, collection_items_site_ids, collection_items_names, collection_items_types)
   
    handle_collection_job_items(collection_items, all_collections)
  end
  
  def sync_create_collection_job(copied_collections_origin_ids, copied_collections_site_ids,
    collection_items_origin_ids, collection_items_site_ids, collection_items_names, collection_items_types)
    sync_params = {command: @collection_job.command, item_count: @collection_job.item_count,
                   all_items: @collection_job.all_items, overwrite: @collection_job.overwrite,
                   copied_collections_origin_ids: copied_collections_origin_ids, 
                   copied_collections_site_ids: copied_collections_site_ids,
                   collection_items_origin_ids: collection_items_origin_ids,
                   collection_items_site_ids: collection_items_site_ids,
                   collection_items_names: collection_items_names, collection_items_types: collection_items_types}
    options = {user: current_user, object: @collection_job.collection, action_id: SyncObjectAction.create.id,
               type_id: SyncObjectType.collection_job.id, params: sync_params} 
    SyncPeerLog.log_action(options)
  end
  
  def handle_collection_job_items(collection_items, all_collections)
    collection_items.each do |collected_item| 
      item = collected_item.collected_item_type.constantize.find(collected_item.collected_item_id)
      if @collection_job.command == "remove"  
        sync_remove_collection_item(collected_item, item)      
      elsif @collection_job.command == "copy"
        sync_copy_collection_item(collected_item, item, all_collections)
      end
    end
  end
  
  def sync_remove_collection_item(collected_item, item)
    sync_params = {item_id: item.origin_id, item_site_id: item.site_id,
                  collected_item_type: collected_item.collected_item_type}
    options = {user: current_user, object: @collection_job.collection, action_id: SyncObjectAction.remove.id,
              type_id: SyncObjectType.collection_item.id, params: sync_params}              
     SyncPeerLog.log_action(options)
  end
  
  def sync_copy_collection_item(collected_item, item, all_collections)
    sync_params = {item_id: item.origin_id, item_site_id: item.site_id,
                  collected_item_type: collected_item.collected_item_type,
                  collected_item_name: collected_item.name}

    if @collection_job.overwrite
      sync_params = sync_params.reverse_merge(annotation: collected_item.annotation, added_by_user_id: collected_item.added_by_user_id,
                                created_at: collected_item.created_at, updated_at: collected_item.updated_at)
    end
    
    if current_user.can_edit_collection?(@collection_job.collection)
      refs = ""
      collected_item.refs.each do |reference|
        refs += reference.full_reference + ","
      end
      sync_params = sync_params.reverse_merge(references: refs)
    end
         
    all_collections.each do |col|
     options = {user: current_user, object: col, action_id: SyncObjectAction.copy.id,
                type_id: SyncObjectType.collection_item.id, params: sync_params}                              
      SyncPeerLog.log_action(options)
    end
  end
  
  def sync_create_collection(new_collection)
    sync_params = {name: new_collection.name}
    options = {user: current_user, object: new_collection, action_id: SyncObjectAction.create.id,
               type_id: SyncObjectType.collection.id, params: sync_params} 
    SyncPeerLog.log_action(options)
  end
  
end
