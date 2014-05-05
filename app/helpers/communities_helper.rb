module CommunitiesHelper
  module ClassMethods
    # Ensure that the user has this in their watch_colleciton, so they will get replies in their newsfeed:
    def auto_collect_helper(what, options = {})
      if options && options[:desired_user_origin_id]
        user = User.find_by_origin_id_and_site_id(options[:desired_user_origin_id], options[:desired_user_site_id])
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
          flash[:notice] ||= ''
          flash[:notice] += ' '
          flash[:notice] += I18n.t(:item_added_to_watch_collection_notice,
                                   collection_name: self.class.helpers.link_to(watchlist.name,
                                                                                  collection_path(watchlist)),
                                   item_name: what.summary_name)
          CollectionActivityLog.create(collection: watchlist, user_id: user.id,
                               activity: Activity.collect, collection_item: collection_item)
        end
      end
    end
    
    def log_community_action(act, opts = {})
      user = opts["user"]
      community = opts["community"]
      opts.delete("community")
      opts.delete("user")
      CommunityActivityLog.create(
        {community_id: community.id, 
         user_id: user.id, 
         activity_id: Activity.send(act).id}.merge(opts)
      )
    end
  end
   
  def self.included(receiver)
    receiver.extend ClassMethods
  end 
end