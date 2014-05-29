module SyncPeerLogHelper
  module ClassMethods
    
    # Methods for Community
    #######################
    # Ensure that the user has this in their watch_colleciton, so they will get replies in their newsfeed:
    def auto_collect_helper(what, options = {})
      if options && options[:user]
        user = options[:user]
      else
        user = current_user
      end
      return if what === user
      watchlist = user.watch_collection
      if what.class == DataObject
        all_revision_ids = DataObject.find_all_by_guid_and_language_id(what.guid, what.language_id, select: 'id').map { |d| d.id }
        collection_item = CollectionItem.where(['collection_id = ? AND collected_item_id IN (?) AND collected_item_type = ?',
                                               watchlist.id, all_revision_ids, what.class.name]).first
      else
        collection_item = CollectionItem.where(['collection_id = ? AND collected_item_id = ? AND collected_item_type = ?', watchlist.id, what.id, what.class.name])
      end
      if collection_item.nil?
        collection_item = begin # We do not care if this fails.
          CollectionItem.create(annotation: options[:annotation], collected_item: what, collection_id: watchlist.id)
        rescue => e
          Rails.logger.error "** ERROR COLLECTING: #{e.message} FROM #{e.backtrace.first}"
          nil
        end
        if collection_item && collection_item.save
          return unless what.respond_to?(:summary_name) # Failsafe.  Most things should.
          unless options[:without_flash]
            flash[:notice] ||= ''
            flash[:notice] += ' '
            flash[:notice] += I18n.t(:item_added_to_watch_collection_notice,
                                     collection_name: self.class.helpers.link_to(watchlist.name,
                                                                                    collection_path(watchlist)),
                                     item_name: what.summary_name)
          end
          CollectionActivityLog.create(collection: watchlist, user_id: user.id,
                               activity: Activity.collect, collection_item: collection_item)
        end
      end
    end
    
    def log_community_action(act, opts = {})
      user = opts[:user]
      community = opts[:community]
      opts.delete("community")
      opts.delete("user")
      CommunityActivityLog.create(
        {community_id: community.id, 
         user_id: user.id, 
         activity_id: Activity.send(act).id}.merge(opts)
      )
    end
    
    # Methods for Community
    #######################
    def log_data_object_action(object, action, options={})
      if options && options["user"]
        user = options["user"]
      else
        user = current_user
      end
      if $STATSD
        $STATSD.increment 'all_curations'
        $STATSD.increment "curations.#{action}"
        if options["data_object"].curator_activity_logs.count == 0
          $STATSD.timing 'time_to_first_curation', Time.now.utc - options["data_object"].created_at
        end
      end
      CuratorActivityLog.factory(
        action: action,
        association: object,
        data_object: options["data_object"],
        user: user
      )
      params = {}
      params[:user] = options["user"]
      params[:without_flash] = true
      auto_collect_helper( options["data_object"], params) unless options[:collect] === false # SPG asks for all curation to add the item to their watchlist.
    end
    
  end
   
  def self.included(receiver)
    receiver.extend ClassMethods
  end 
end