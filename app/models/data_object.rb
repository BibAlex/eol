require 'set'
require 'uuid'
require 'erb'

# Represents any kind of object imported from a ContentPartner, eg. an image, article, video, etc.  This is one
# of our primary models, and an awful lot of work occurs here.
class DataObject < ActiveRecord::Base

  @@maximum_rating = 5.0
  @@minimum_rating = 0.5

  include ModelQueryHelper
  include EOL::ActivityLoggable
  include EOL::PeerSites

  belongs_to :data_type
  belongs_to :data_subtype, :class_name => DataType.to_s, :foreign_key => :data_subtype_id
  belongs_to :language
  belongs_to :license
  belongs_to :mime_type

  # this is the DataObjectTranslation record which links this translated object
  # to the original data object
  has_one :data_object_translation
  has_one :users_data_object

  has_many :top_images
  has_many :feed_data_objects
  has_many :top_concept_images
  has_many :agents_data_objects
  has_many :data_objects_hierarchy_entries
  has_many :data_objects_taxon_concepts
  has_many :curated_data_objects_hierarchy_entries
  has_many :all_curated_data_objects_hierarchy_entries, :class_name => CuratedDataObjectsHierarchyEntry.to_s, :source => :curated_data_objects_hierarchy_entries, :foreign_key => :data_object_guid, :primary_key => :guid
  has_many :comments, :as => :parent
  has_many :data_objects_harvest_events
  has_many :harvest_events, :through => :data_objects_harvest_events
  has_many :data_objects_table_of_contents
  has_many :data_objects_info_items
  has_many :info_items, :through => :data_objects_info_items
  has_many :taxon_concept_exemplar_images
  has_many :worklist_ignored_data_objects
  has_many :collection_items, :as => :object
  has_many :containing_collections, :through => :collection_items, :source => :collection
  has_many :translations, :class_name => DataObjectTranslation.to_s, :foreign_key => :original_data_object_id
  has_many :curator_activity_logs, :foreign_key => :object_id, :conditions => 'changeable_object_type_id IN (#{ [ ChangeableObjectType.data_object.id, ChangeableObjectType.data_objects_hierarchy_entry.id,
    ChangeableObjectType.curated_data_objects_hierarchy_entry.id, ChangeableObjectType.users_data_object.id ].join(",") } )'
  has_many :users_data_objects_ratings, :foreign_key => 'data_object_guid', :primary_key => :guid
  # has_many :all_comments, :class_name => Comment.to_s, :foreign_key => 'parent_id', :finder_sql => 'SELECT c.* FROM #{Comment.full_table_name} c JOIN #{DataObject.full_table_name} do ON (c.parent_id = do.id) WHERE do.guid=\'#{guid}\' AND c.parent_type = \'DataObject\''
  # TODO - I don't have time to make sure this fix isn't going to break or slow down other parts of the site, so
  # I'm calling this the 'better' method. DO NOT call this when using core relationships - it will not take just id and guid
  # from data_objects and you'll have way more data returned than you want
  has_many :all_comments, :class_name => Comment.to_s, :through => :all_versions, :source => :comments, :primary_key => :guid
  # the select_with_include library doesn't allow to grab do.* one time, then do.id later on. So in order
  # to use this with preloading I highly recommend doing DataObject.preload_associations(data_objects, :all_versions) on an array
  # of data_objects which already has everything else preloaded
  has_many :all_versions, :class_name => DataObject.to_s, :foreign_key => :guid, :primary_key => :guid, :select => 'id, guid, language_id'
  has_many :all_published_versions, :class_name => DataObject.to_s, :foreign_key => :guid, :primary_key => :guid, :order => "id desc",
    :conditions => 'published = 1'
  has_many :media_download_statuses, :as => :target_row

  has_and_belongs_to_many :hierarchy_entries
  has_and_belongs_to_many :audiences
  has_and_belongs_to_many :refs
  has_and_belongs_to_many :published_refs, :class_name => Ref.to_s, :join_table => 'data_objects_refs',
    :association_foreign_key => 'ref_id', :conditions => 'published=1 AND visibility_id=#{Visibility.visible.id}'

  has_and_belongs_to_many :agents
  has_and_belongs_to_many :toc_items, :join_table => 'data_objects_table_of_contents', :association_foreign_key => 'toc_id'
  has_and_belongs_to_many :taxon_concepts

  attr_accessor :vetted_by # who changed the state of this object? (not persisted on DataObject but required by observer)

  named_scope :visible, lambda { { :conditions => { :visibility_id => Visibility.visible.id } }}
  named_scope :preview, lambda { { :conditions => { :visibility_id => Visibility.preview.id } }}

  validates_presence_of :description, :if => :is_text?
  validates_presence_of :rights_holder, :if => :rights_required?
  validates_inclusion_of :rights_holder, :in => '', :unless => :rights_required?
  validates_length_of :rights_statement, :maximum => 300

  before_validation :default_values
  after_create :clean_values

  index_with_solr :keywords => [ :object_title ], :fulltexts => [ :description ]

  define_core_relationships :select => {
      :data_objects => '*',
      :agents => [:full_name, :homepage, :logo_cache_url],
      :agents_data_objects => :view_order,
      :names => :string,
      :hierarchy_entries => [ :published, :visibility_id, :taxon_concept_id ],
      :languages => :iso_639_1,
      :info_items => :schema_value,
      :data_types => :schema_value,
      :vetted => :view_order,
      :table_of_contents => '*',
      :licenses => '*' },
    :include => [:data_type, :mime_type, :language, :license, {:info_items => :toc_item},
      {:hierarchy_entries => [:name, { :hierarchy => :agent }] }, {:agents_data_objects => [ { :agent => :user }, :agent_role]}]

  def self.maximum_rating
    @@maximum_rating
  end

  def self.minimum_rating
    @@minimum_rating
  end

  # this method is not just sorting by rating
  def self.sort_by_rating(data_objects, taxon_concept = nil, sort_order = [:type, :toc, :visibility, :vetted, :rating, :date])
    data_objects.sort_by do |obj|
      obj_association = obj.association_with_exact_or_best_vetted_status(taxon_concept)
      obj_vetted = obj_association.vetted unless obj_association.nil?
      obj_visibility = obj_association.visibility unless obj_association.nil?
      type_order = obj.data_type_id
      toc_view_order = (!obj.is_text? || obj.toc_items.blank?) ? 0 : obj.toc_items[0].view_order
      vetted_view_order = obj_vetted.blank? ? 0 : obj_vetted.view_order
      visibility_view_order = 2
      visibility_view_order = 1 if obj_visibility && obj_visibility.id == Visibility.preview.id
      visibility_view_order = 0 if obj_visibility.blank?
      inverted_rating = obj.data_rating * -1 # Is this throwing an ArgumentError?  Restart your worker(s)!
      inverted_id = obj.id * -1
      sort = []
      sort_order.each do |item|
        sort << type_order if item == :type
        sort << toc_view_order if item == :toc
        sort << visibility_view_order if item == :visibility
        sort << vetted_view_order if item == :vetted
        sort << inverted_rating if item == :rating
        sort << inverted_id if item == :date
      end
      sort
    end
  end

  def self.sort_by_created_date(data_objects)
    data_objects.sort_by do |obj|
      created_at = obj.created_at || 0
      created_at
    end
  end
  
  def self.sort_by_language_view_order_and_label(data_objects)
    data_objects.sort_by do |obj|
      obj.language ? [ obj.language.sort_order, obj.language.source_form ] : [ 0, 0 ]
    end
  end

  # TODO - this smells like a good place to use a Strategy pattern.  The user can have certain behaviour based
  # on their access.
  def self.filter_list_for_user(data_objects, options={})
    return [] if data_objects.blank?
    visibility_ids = [Visibility.visible.id]
    vetted_ids = [Vetted.trusted.id, Vetted.unknown.id, Vetted.untrusted.id]
    show_preview = false

    # Show all vetted states unless there is a user that DOES NOT want to see vetted content
    # AND is not a curator of this clade (curators always see all content in their clade)
    # AND is not an admin (admins always see all content)
    if options[:user]
      # admins see everything
      if options[:user].is_admin?
        vetted_ids += [Vetted.untrusted.id, Vetted.unknown.id, Vetted.inappropriate.id]
        visibility_ids = Visibility.all_ids.dup
      # curators see invisible objects
      elsif options[:user].is_curator? && options[:user].min_curator_level?(:full)
        visibility_ids << Visibility.invisible.id
      end
      # the only scenario to see ONLY TRUSTED objects
      if !options[:user].is_admin?
        vetted_ids = [Vetted.trusted.id]
      end
    end

    if options[:toc_id] == TocItem.wikipedia
      show_preview = true
    end

    # removing from the array the ones not mathching our criteria
    data_objects.compact.select do |d|
      tc = options[:taxon_concept]
      dato_association = d.association_with_exact_or_best_vetted_status(tc)
      dato_vetted_id = dato_association.vetted_id unless dato_association.nil?
      dato_visibility_id = dato_association.visibility_id unless dato_association.nil?
      # partners see all their PREVIEW or PUBLISHED objects
      # user can see preview objects
      if show_preview && dato_visibility_id == Visibility.preview.id
        true
      # Users can see text that they have added:
      elsif d.added_by_user? && d.users_data_object.user_id == options[:user].id
        true
      # otherwise object must be PUBLISHED and in the vetted and visibility selection
      elsif d.published == true && vetted_ids.include?(dato_vetted_id) && visibility_ids.include?(dato_visibility_id)
        true
      else
        false
      end
    end
  end

  # for RSS feeds
  def self.for_feeds(type = :all, taxon_concept_id = nil, max_results = 100)
    if type == :text
      data_type_ids = [DataType.text_type_ids[0]]
    elsif type == :images
      data_type_ids = [DataType.image_type_ids[0]]
    else
      data_type_ids = [DataType.image_type_ids[0], DataType.text_type_ids[0]]
    end

    if taxon_concept_id.nil?
      lookup_ids = HierarchyEntry.find_all_by_hierarchy_id_and_parent_id(Hierarchy.default.id, 0).collect{|he| he.taxon_concept_id}
    else
      lookup_ids = [taxon_concept_id]
    end

    data_objects = DataObject.find_by_sql("
      SELECT do.id, do.guid, do.created_at
      FROM feed_data_objects fdo
      JOIN #{DataObject.full_table_name} do ON (fdo.data_object_id=do.id)
      WHERE fdo.taxon_concept_id IN (#{lookup_ids.join(',')})
      AND do.published=1
      AND do.data_type_id IN (#{data_type_ids.join(',')})
      AND do.created_at IS NOT NULL
      AND do.created_at != '0000-00-00 00:00:00'").uniq
    data_objects.sort_by{ |d| d.created_at }
    data_objects = DataObject.core_relationships.find_all_by_id(data_objects.collect{ |d| d.id })
    DataObject.preload_associations(data_objects, [ { :data_objects_hierarchy_entries =>
      { :hierarchy_entry => :name } }, :curated_data_objects_hierarchy_entries ],
      :select => {
        :hierarchy_entries => '*',
        :names => '*',
        :data_objects_hierarchy_entries => '*',
        :curated_data_objects_hierarchy_entries => '*'
      } )
    data_objects
  end

  def self.create_user_text(params, options)
    unless params[:license_id].to_i == License.public_domain.id || ! params[:rights_holder].blank?
      params[:rights_holder] = options[:user].full_name
    end
    dato = DataObject.new(params.reverse_merge!({:published => true}))
    if dato.save
      begin
        dato.toc_items = Array(TocItem.find(options[:toc_id]))
        dato.build_relationship_to_taxon_concept_by_user(options[:taxon_concept], options[:user])
      rescue => e
        dato.update_attribute(:published, false)
        raise e
      ensure
        dato.update_solr_index
      end
    end
    dato
  end

  def self.latest_published_version_of(data_object_id)
    obj = DataObject.find_by_sql("SELECT do.* FROM data_objects do_old JOIN data_objects do ON (do_old.guid=do.guid) WHERE do_old.id=#{data_object_id} AND do.published=1 ORDER BY id desc LIMIT 1")
    return nil if obj.blank?
    return obj[0]
  end

  def self.latest_published_version_of_guid(guid, options={})
    options[:return_only_id] ||= false
    select = (options[:return_only_id]) ? 'id' : '*'
    obj = DataObject.find_by_sql("SELECT #{select} FROM data_objects WHERE guid='#{guid}' AND published=1 ORDER BY id desc LIMIT 1")
    return nil if obj.blank?
    return obj[0]
  end

  def self.image_cache_path(cache_url, size = '580_360', specified_content_host = nil)
    return if cache_url.blank? || cache_url == 0
    size = size ? "_" + size.to_s : ''
    ContentServer.cache_path(cache_url, specified_content_host) + "#{size}.#{$SPECIES_IMAGE_FORMAT}"
  end

  def self.load_for_title_only(find_these)
    DataObject.find(find_these, :select => 'id, object_title', :include => [:toc_items, :data_type])
  end

  # NOTE - you probably want to check that the user performing this has rights to do so, before calling this.
  def replicate(params, options)
    unless params[:license_id].to_i == License.public_domain.id || ! params[:rights_holder].blank?
      params[:rights_holder] = options[:user].full_name
    end
    new_dato = DataObject.new(params.reverse_merge!(:guid => self.guid, :published => 1))
    if new_dato.save
      begin
        new_dato.toc_items = Array(TocItem.find(options[:toc_id]))
        new_dato.unpublish_previous_revisions

        new_dato.users_data_object = users_data_object.replicate(new_dato)
        new_vetted_id_for_cdohes = (user.min_curator_level?(:full) || user.is_admin?) ? Vetted.trusted.id : Vetted.unknown.id
        if all_cdohe_associations = new_dato.all_curated_data_objects_hierarchy_entries
          all_cdohe_associations.each {|cdohe_assoc| cdohe_assoc.replicate(new_vetted_id_for_cdohes)} unless all_cdohe_associations.blank?
        end
        DataObjectsTaxonConcept.find_or_create_by_taxon_concept_id_and_data_object_id(users_data_object.taxon_concept_id, new_dato.id)
      rescue => e
        new_dato.update_attribute(:published, false)
        raise e
      ensure
        new_dato.update_solr_index
      end
    end
    new_dato
  end


  def created_by_user?
    user != nil
  end

  def user
    @udo ||= UsersDataObject.find_by_data_object_id(id)
    @udo_user ||= @udo.nil? ? nil : User.find(@udo.user_id)
  end
  def user_id
    user.id
  end

  def taxon_concept_for_users_text
    unless user.nil?
      udo = UsersDataObject.find_by_data_object_id(id)
      TaxonConcept.find(udo.taxon_concept_id)
    end
  end

  def rate(user, new_rating)
    existing_ratings = UsersDataObjectsRating.find_all_by_data_object_guid(guid)
    users_current_ratings, other_ratings = existing_ratings.partition { |r| r.user_id == user.id }

    weight = user.is_curator? ? user.curator_level.rating_weight : 1
    new_udor = nil
    if users_current_ratings.blank?
      new_udor = UsersDataObjectsRating.create(:data_object_guid => guid, :user_id => user.id,
                                               :rating => new_rating, :weight => weight)
    elsif (new_udor = users_current_ratings.first).rating != new_rating
      new_udor.update_attribute(:rating, new_rating)
      new_udor.update_attribute(:weight, weight)
    end

    self.update_attribute(:data_rating, ratings_calculator(other_ratings + [new_udor]))
  end

  def recalculate_rating(debug = false)
    ratings = UsersDataObjectsRating.find_all_by_data_object_guid(guid)
    self.update_attribute(:data_rating, ratings_calculator(ratings, debug))
    self.data_rating
  end

  def ratings_calculator(ratings, debug = false)
    count = 0
    self.data_rating = ratings.blank? ? 2.5 : ratings.inject(0) { |sum, r|
      if r.respond_to?(:weight)
        sum += (r.rating * r.weight)
        count += r.weight
        logger.warn ".. Giving score of #{r.rating} weight of #{r.weight}." if debug
      else
        sum += r.rating
        count += 1
        logger.warn ".. Giving score of #{r.rating} weight of 1 (it had no weight specified)." if debug
      end
      sum
    }.to_f / count
  end

  def rating_from_user(u)
    ratings_from_user = users_data_objects_ratings.select{ |udor| udor.user_id == u.id }
    return ratings_from_user[0] unless ratings_from_user.blank?
  end

  def safe_rating
    return self.data_rating if self.data_rating >= @@minimum_rating && self.data_rating <= @@maximum_rating
    logger.warn "!! WARNING: data object #{self.id} had a data_rating of #{self.data_rating}. Attempted fix:"
    rating = recalculate_rating(true)
    if rating <= @@minimum_rating
      logger.error "** ERROR: data object #{self.id} had a *calculated* rating of #{rating}."
      return @@minimum_rating
    elsif rating > @@maximum_rating
      logger.error "** ERROR: data object #{self.id} had a *calculated* rating of #{rating}."
      return @@maximum_rating
    else
      return rating
    end
  end

  # Add a comment to this data object
  def comment(user, body)
    comment = comments.create :user_id => user.id, :body => body
    user.comments.reload # be friendly - update the user's comments automatically
    return comment
  end

  # Find the Agent (only one) that supplied this data object to EOL.
  def data_supplier_agent
    # this is a bit of a shortcut = the hierarchy's agent should be the same as the agent
    # that contributed the resource. DataObject should only live in a single hierarchy
    @data_supplier_agent ||= hierarchy_entries[0].hierarchy.agent rescue nil
    if !@data_supplier_agent.blank?
      if (!@data_supplier_agent.homepage?)
        @data_supplier_agent = Agent.find_by_id(@data_supplier_agent.id)
      end
    end
    return @data_supplier_agent
  end

  def citable_data_supplier
    return nil if data_supplier_agent.blank?
    EOL::Citable.new( :agent_id => data_supplier_agent.id,
                                  :link_to_url => data_supplier_agent.homepage,
                                  :display_string => data_supplier_agent.full_name,
                                  :logo_cache_url => data_supplier_agent.logo_cache_url,
                                  :type =>I18n.t(:supplier))
  end

  def citable_rights_holder
    return nil if rights_holder.blank?
    EOL::Citable.new( :display_string => rights_holder, :type => I18n.t("rights_holder"))
  end

  def citable_entities
    citables = []

    unless license.blank?
      citables << EOL::Citable.new( :link_to_url => license.source_url,
                                    :display_string => license.description,
                                    :logo_path => license.logo_url,
                                    :type => I18n.t("license"))
    end

    agents_data_objects.each do |ado|
      if ado.agent_role && ado.agent
        citables << ado.agent.citable(ado.agent_role.label)
      end
    end

    unless data_supplier_agent.blank?
      citables << citable_data_supplier
    end

    unless rights_statement.blank?
      citables << EOL::Citable.new( :display_string => rights_statement,
                                    :type => I18n.t("rights"))
    end

    unless rights_holder.blank?
      citables << citable_rights_holder
    end

    unless location.blank?
      citables << EOL::Citable.new( :display_string => location,
                                    :type => I18n.t(:location))
    end

    unless source_url.blank?
      citables << EOL::Citable.new( :link_to_url => source_url,
                                    :display_string => 'View original data object',
                                    :type => I18n.t("source_url"))
    end

    unless created_at.blank? || created_at == '0000-00-00 00:00:00'
      citables << EOL::Citable.new( :display_string => created_at.strftime("%B %d, %Y"),
                                    :type => I18n.t("indexed"))
    end

    unless bibliographic_citation.blank?
      citables << EOL::Citable.new( :display_string => bibliographic_citation,
                                    :type => I18n.t("citation"))
    end

    citables
  end

  # need supplier as content partner object, is this right ?
  def content_partner
    # TODO - change this, since it would be more efficient to go through hierarchy_entries... but the first attempt
    # (using hierarchy_entries.first) failed to find the correct data in observed cases. WEB-2850
    return @content_partner if @content_partner
    @content_partner = data_objects_hierarchy_entries.first.hierarchy_entry.hierarchy.resource.content_partner rescue (harvest_events.last.resource.content_partner rescue nil)
  end

  # 'owner' chooses someone responsible for this data object in order of preference
  # this method returns [OwnerName, OwnerUser || nil]
  def owner
    # rights holder is preferred
    return rights_holder, nil unless rights_holder.blank?
    unless agents_data_objects.empty?
      AgentsDataObject.sort_by_role_for_owner(agents_data_objects)
      if first_agent = agents_data_objects.first.agent
        return first_agent.full_name, first_agent.user
      end
    end
  end

  # Find all of the authors associated with this data object, including those that we dynamically add elsewhere
  def authors
    @default_authors = agents_data_objects.select{ |ado| ado.agent_role_id == AgentRole.author.id }.collect {|ado| ado.agent }.compact
  end

  def revisions
    DataObject.find_all_by_guid_and_language_id(guid, language_id)
  end

  def image?
    return DataType.image_type_ids.include?(data_type_id)
  end
  alias is_image? image?

  def text?
    return DataType.text_type_ids.include?(data_type_id)
  end
  alias is_text? text?

  def sound?
    return DataType.sound_type_ids.include?(data_type_id)
  end
  alias is_sound? sound?

  def video?
    return DataType.video_type_ids.include?(data_type_id)
  end
  alias is_video? video?

  # NOTE: does not include image maps @see is_image_map? is used by en_type(object) in ApplicationHelper
  def map?
    return DataType.map_type_ids.include?(data_type_id)
  end
  alias is_map? map?

  # NOTE: Specifically for image maps
  def image_map?
    self.is_image? && DataType.map_type_ids.include?(data_subtype_id)
  end
  alias is_image_map? image_map?

  def iucn?
    return data_type_id == DataType.iucn.id
  end
  alias is_iucn? iucn?

  def has_object_cache_url?
    return false if object_cache_url.blank? or object_cache_url == 0
    return true
  end

  def is_subtype_map?
    return true if self.data_subtype.id == DataType.map.id
    false
  end

  def map_from_DiscoverLife?
    last_harvest_event = self.harvest_events.last rescue nil
    if last_harvest_event
      if r = last_harvest_event.resource
        return true if r.from_DiscoverLife? and self.is_subtype_map?
      end
    end
    false
  end

  def access_image_from_remote_server?(size)
    return true if ['580_360', :orig].include?(size) && self.map_from_DiscoverLife?
    # we can add here other criterias for image to be hosted remotely
    false
  end

  def has_thumbnail?
    ((is_video? || is_sound?) && thumbnail_cache_url?) || (is_image? && object_cache_url?)
  end

  def thumb_or_object(size = '580_360', specified_content_host = nil)
    if self.is_video? || self.is_sound?
      return DataObject.image_cache_path(thumbnail_cache_url, size, specified_content_host)
    elsif has_object_cache_url?
      return DataObject.image_cache_path(object_cache_url, size, specified_content_host)
    else
      return '#' # Really, this is an error, but we want to handle it pseudo-gracefully.
    end
  end

  # Returns path to a thumbnail.
  def smart_thumb
    thumb_or_object('98_68')
  end

  # Returns path to a "larger" thumbnail (a'la main page).
  def smart_medium_thumb
    thumb_or_object('260_190')
  end

  # Returns path to the *full* image.
  def smart_image
    thumb_or_object
  end

  def original_image
    thumb_or_object(:orig)
  end

  def sound_url
    if !object_cache_url.blank? && !object_url.blank?
      filename_extension = File.extname(object_url).downcase
      return ContentServer.cache_path(object_cache_url) + filename_extension
    elsif mime_type.label('en') == 'audio/mpeg'
      return has_object_cache_url? ? ContentServer.cache_path(object_cache_url) + '.mp3' : ''
    else
      return object_url
    end
  end

  def video_url
    if !object_cache_url.blank? && !object_url.blank?
      filename_extension = File.extname(object_url)
      return ContentServer.cache_path(object_cache_url) + filename_extension
    elsif data_type.label('en') == 'Flash'
      return has_object_cache_url? ? ContentServer.cache_path(object_cache_url) + '.flv' : ''
    else
      return object_url
    end
  end

  # TODO - wow, this is expensive (IFF you pass in :published) ... we should really consider optimizing this, since
  # it's actually used quite often. ...and in some cases, just to get the ID of the first one.  Ouch.
  # :published -> :strict - return only published taxon concepts
  # :published -> :preferred - same as above, but returns unpublished taxon concepts if no published ones are found
  # NOTE - honestly, I don't know if I trust this anymore anyway!  Compare to #all_associations, for example.
  def get_taxon_concepts(opts = {})
    return @taxon_concepts if @taxon_concepts
    if created_by_user?
      @taxon_concepts = [taxon_concept_for_users_text]
    else
      @taxon_concepts = taxon_concepts
    end
    if opts[:published]
      published, unpublished = @taxon_concepts.partition {|item| item.published?}
      @taxon_concepts = (!published.empty? || opts[:published] == :strict) ? published : unpublished
    end
    @taxon_concepts
  end

  def linked_taxon_concept
    get_taxon_concepts.first
  end

  def update_solr_index
    if self.published
      DataObject.with_master do
        self.class.uncached do
          # creating another instance to remove any change of this instance not
          # matching the database and indexing stale or changed information
          revisions_by_date.each do |object_to_index|
            EOL::Solr::DataObjectsCoreRebuilder.reindex_single_object(object_to_index)
          end
        end
      end
    else
      # hidden, so delete it from solr
      EOL::Solr::DataObjectsCoreRebuilder.delete_single_object(self.id)
    end
  end

  def in_wikipedia?
    toc_items.include?(TocItem.wikipedia)
  end

  def publish_wikipedia_article(taxon_concept)
    dato_association = self.association_with_exact_or_best_vetted_status(taxon_concept)
    return false unless in_wikipedia?
    return false unless dato_association.visibility_id == Visibility.preview.id

    connection.execute("UPDATE data_objects SET published=0 WHERE guid='#{guid}'");
    reload

    dato_vetted = self.vetted_by_taxon_concept(taxon_concept)
    dato_vetted_id = dato_vetted.id unless dato_vetted.nil?
    dato_visibility = self.visibility_by_taxon_concept(taxon_concept)
    dato_visibility_id = dato_visibility.id unless dato_visibility.nil?

    dato_association.visibility_id = Visibility.visible.id
    dato_association.vetted_id = Vetted.trusted.id
    dato_association.save!
    self.update_attribute(:published, 1)
  end

  def visible_references
    @all_refs ||= refs.delete_if {|r| r.published != 1 || r.visibility_id != Visibility.visible.id}
  end

  def to_s
    "[DataObject id:#{id}]"
  end

  # this method will be run on an instance of an object unlike the above methods. It is best to have preloaded
  # all_published_versions in order for this method to be efficient
  # NOTE: English is basically the default language in the DB and we have cases where some revisions have
  # a language == English, but other revisions have a language_id of 0. That explains some
  # of the complicated logic in this method
  def latest_published_version_in_same_language
    latest_version_in_same_language(:check_only_published => true)
  end
  
  def latest_version_in_same_language(params = {})
    params[:check_only_published] = true unless params.has_key?(:check_only_published)
    versions_to_look_at = params[:check_only_published] ? all_published_versions : all_versions
    
    return nil if versions_to_look_at.blank?
    versions_to_look_at_in_language = versions_to_look_at.dup
    # if this object has a language, and its different from the revision language,
    # except when this is English and the other has no language
    versions_to_look_at_in_language.delete_if{ |d| self.language && (d.language_id != self.language.id && !(d.language_id == 0 && self.language == Language.english)) }
    # if this object has no language, and the revision does have a language other than English
    versions_to_look_at_in_language.delete_if{ |d| !self.language && d.language && d.language != Language.english }
    versions_to_look_at_in_language.sort_by{ |d| d.id }.reverse.first
  end
  
  def is_latest_published_version_in_same_language?
    return @is_latest_published_version unless @is_latest_published_version.nil?
    the_latest = latest_published_version_in_same_language
    @is_latest_published_version = (the_latest && the_latest.id == self.id) ? true : false
  end

  # To retrieve an association for the data object by using given hierarchy entry
  def association_for_hierarchy_entry(hierarchy_entry)
    association = data_objects_hierarchy_entries.detect{ |dohe| dohe.hierarchy_entry_id == hierarchy_entry.id }
    if association.blank?
      association = all_curated_data_objects_hierarchy_entries.detect{ |dohe| dohe.hierarchy_entry_id == hierarchy_entry.id }
    end
    association
  end

  # To retrieve an association for the data object by using given taxon concept
  def association_for_taxon_concept(taxon_concept)
    association = data_objects_hierarchy_entries.detect{ |dohe| dohe.hierarchy_entry.taxon_concept_id == taxon_concept.id }
    if association.blank?
      association = all_curated_data_objects_hierarchy_entries.detect{ |dohe| dohe.hierarchy_entry.taxon_concept_id == taxon_concept.id }
    end
    if association.blank?
      association = users_data_object if users_data_object && users_data_object.taxon_concept_id == taxon_concept.id
    end
    association
  end

  # To retrieve an association for the data object if taxon concept and hierarchy entry are unknown
  def association_with_best_vetted_status
    associations = (data_objects_hierarchy_entries + all_curated_data_objects_hierarchy_entries + [users_data_object]).compact
    return if associations.empty?
    associations.sort_by{ |a| a.vetted.view_order }.first
  end

  # To retrieve the vetted status of an association by using given hierarchy entry
  def vetted_by_hierarchy_entry(hierarchy_entry)
    association = association_for_hierarchy_entry(hierarchy_entry)
    return association.vetted unless association.blank?
    return nil
  end

  # To retrieve the vetted status of an association by using given taxon concept
  def vetted_by_taxon_concept(taxon_concept, options={})
    if association = association_with_exact_or_best_vetted_status(taxon_concept, options)
      return association.vetted
    end
    return nil
  end

  # To retrieve an exact association(if exists) for the given taxon concept,
  # otherwise retrieve an association with best vetted status.
  # when :find_best is used, we want to prefer the best vetted status
  def association_with_exact_or_best_vetted_status(taxon_concept, options={})
    if options[:find_best] == true && association = association_with_best_vetted_status
      return association
    end
    association = association_for_taxon_concept(taxon_concept)
    return association unless association.blank?
    if !options[:find_best]
      association = association_with_best_vetted_status
      return association
    end
    return nil
  end

  # To retrieve the visibility status of an association by using taxon concept
  def visibility_by_taxon_concept(taxon_concept, options={})
    if association = association_with_exact_or_best_vetted_status(taxon_concept, options)
      return association.visibility
    end
    return nil
  end
  
  # will return the class name and label used to generate the colored box showing
  # this object's curation status: Green/Trusted, Gray/Unreviewed, Red/Untrusted, Red/Hidden
  # or if none available: nil, nil
  def status_class_and_label_by_taxon_concept(taxon_concept)
    if best_association = association_with_exact_or_best_vetted_status(taxon_concept)
      if best_association.visibility == Visibility.invisible
        return 'untrusted', I18n.t(:hidden)
      else
        status_class = case best_association.vetted
          when Vetted.unknown       then 'unknown'
          when Vetted.untrusted     then 'untrusted'
          when Vetted.trusted       then 'trusted'
          when Vetted.inappropriate then 'inappropriate'
          else nil
        end
        status_label = case best_association.vetted
          when Vetted.unknown then I18n.t(:unreviewed)
          else best_association.vetted.label
        end
        return status_class, status_label
      end
    end
    return nil, nil
  end

  # To retrieve the reasons provided while untrusting or hiding an association
  def reasons(hierarchy_entry, activity)
    if hierarchy_entry.class == UsersDataObject
      log = CuratorActivityLog.find_all_by_data_object_guid_and_changeable_object_type_id_and_activity_id(
        guid, ChangeableObjectType.users_data_object.id, activity.id
      ).last
      log ? log.untrust_reasons.collect{|ur| ur.untrust_reason_id} : []
    elsif hierarchy_entry.associated_by_curator
      log = CuratorActivityLog.find_all_by_data_object_guid_and_changeable_object_type_id_and_activity_id_and_hierarchy_entry_id(
        guid, ChangeableObjectType.curated_data_objects_hierarchy_entry.id, activity.id, hierarchy_entry.id
      ).last
      log ? log.untrust_reasons.collect{|ur| ur.untrust_reason_id} : []
    else
      log = CuratorActivityLog.find_all_by_data_object_guid_and_changeable_object_type_id_and_activity_id_and_hierarchy_entry_id(
        guid, ChangeableObjectType.data_objects_hierarchy_entry.id, activity.id, hierarchy_entry.id
      ).last
      log ? log.untrust_reasons.collect{|ur| ur.untrust_reason_id} : []
    end
  end

  # To retrieve the reasons provided while untrusting an association
  def untrust_reasons(hierarchy_entry)
    reasons(hierarchy_entry, Activity.untrusted)
  end

  # To retrieve the reasons provided while hiding an association
  def hide_reasons(hierarchy_entry)
    reasons(hierarchy_entry, Activity.hide)
  end

  def flickr_photo_id
    if matches = source_url.match(/flickr\.com\/photos\/.*?\/([0-9]+)\//)
      return matches[1]
    end
    nil
  end

  def curated_hierarchy_entries
    dohes = []
    latest_revision = latest_published_revision.nil? ? revisions_by_date.first : latest_published_revision
    if latest_revision
      dohes = latest_revision.data_objects_hierarchy_entries.compact.map { |dohe|
        if dohe.hierarchy_entry && he = dohe.hierarchy_entry.dup
          he.vetted = dohe.vetted
          he.visibility = dohe.visibility
        end
        he
      }.compact
    end
    cdohes = all_curated_data_objects_hierarchy_entries.compact.map { |cdohe|
      if cdohe.hierarchy_entry && he = cdohe.hierarchy_entry.dup
        he.associated_by_curator = cdohe.user
        he.vetted = cdohe.vetted
        he.visibility = cdohe.visibility
      end
      he
    }.compact
    dohes + cdohes
  end

  def published_entries
    curated_hierarchy_entries.select{ |he| he.published == 1 }
  end

  def unpublished_entries
    curated_hierarchy_entries.select{ |he| he.published != 1 }
  end

  # Preview visibility CAN apply here, so be careful. By default, preview is included; otherwise, pages would show up
  # without any association at all, and that would be confusing. But note that preview associations should NOT be
  # curatable!
  def filtered_associations(which = {})
    good_ids = [Visibility.visible.id]
    good_ids << Visibility.preview.id unless which[:preview] == false
    good_ids << Visibility.invisible.id if which[:invisible]
    all_associations.select {|asoc| good_ids.include?(asoc.visibility_id) }.compact
  end

  def all_associations
    @all_assoc ||= (published_entries + unpublished_entries + [latest_published_users_data_object]).compact
  end

  def all_published_associations
    @all_pub_assoc ||= (published_entries + [latest_published_users_data_object]).compact
  end

  def latest_published_users_data_object
    latest_published_revision.users_data_object if users_data_object
  end

  def first_concept_name
    first_hierarchy_entry.name.string rescue nil
  end

  def first_taxon_concept
    if created_by_user?
      return users_data_object.taxon_concept
    end
    first_hierarchy_entry.taxon_concept rescue nil
  end

  def first_hierarchy_entry(options={})
    sorted_entries = HierarchyEntry.sort_by_vetted(published_entries)
    best_first_entry = sorted_entries[0] rescue nil
    if best_first_entry.nil? && options[:include_preview_entries]
      sorted_entries = HierarchyEntry.sort_by_vetted(curated_hierarchy_entries)
      best_first_entry = sorted_entries[0] rescue nil
    end
    best_first_entry
  end

  def best_title
    return object_title unless object_title.blank?
    return toc_items.first.label unless toc_items.blank?
    return data_type.simple_type
  end
  alias :summary_name :best_title

  def short_title
    return object_title unless object_title.blank?
    # TODO - ideally, we should extract some of the logic from data_objects/show to make this "Image of Procyon Lotor".
    return data_type.label if description.blank?
    st = description.gsub(/\n.*$/, '')
    st.truncate(32)
  end

  def description_teaser
    full_teaser = Sanitize.clean(description[0..300], :elements => %w[b i], :remove_contents => %w[table script]).strip
    return nil if full_teaser.blank?
    truncated_teaser = full_teaser.split[0..10].join(' ').balance_tags
    truncated_teaser << '...' if full_teaser.length > truncated_teaser.length
    truncated_teaser
  end

  def added_by_user?
    users_data_object && !users_data_object.user.blank?
  end

  def add_curated_association(user, hierarchy_entry)
    taxon_concept_id = hierarchy_entry.taxon_concept.id
    vetted_id = user.min_curator_level?(:full) ? Vetted.trusted.id : Vetted.unknown.id
    cdohe = CuratedDataObjectsHierarchyEntry.create(:hierarchy_entry_id => hierarchy_entry.id,
                                                    :data_object_id => self.id, :user_id => user.id,
                                                    :data_object_guid => self.guid,
                                                    :vetted_id => vetted_id,
                                                    :visibility_id => Visibility.visible.id)
    if self.data_type == DataType.image
      TopImage.find_or_create_by_hierarchy_entry_id_and_data_object_id(hierarchy_entry.id, self.id, :view_order => 1)
      TopConceptImage.find_or_create_by_taxon_concept_id_and_data_object_id(taxon_concept_id, self.id, :view_order => 1)
    end
    DataObjectsTaxonConcept.find_or_create_by_taxon_concept_id_and_data_object_id(taxon_concept_id, self.id)
    revisions_by_date.each do |revision|
      if revision.id != self.id
        dotc_exists = DataObjectsTaxonConcept.find_by_taxon_concept_id_and_data_object_id(taxon_concept_id, revision.id)
        dotc_exists.destroy unless dotc_exists.nil?
      end
    end
  end

  def remove_curated_association(user, hierarchy_entry)
    taxon_concept_id = hierarchy_entry.taxon_concept.id
    cdohe = CuratedDataObjectsHierarchyEntry.find_by_data_object_guid_and_hierarchy_entry_id(guid, hierarchy_entry.id)
    raise EOL::Exceptions::ObjectNotFound if cdohe.nil?
    raise EOL::Exceptions::WrongCurator.new("user did not create this association") unless cdohe.user_id == user.id
    cdohe.destroy
    if self.data_type == DataType.image
      tci_exists = TopConceptImage.find_by_taxon_concept_id_and_data_object_id(taxon_concept_id, self.id)
      tci_exists.destroy unless tci_exists.nil?
      ti_exists = TopImage.find_by_hierarchy_entry_id_and_data_object_id(hierarchy_entry.id, self.id)
      ti_exists.destroy unless ti_exists.nil?
    end
    unless still_associated_with_taxon_concept?(taxon_concept_id)
      revisions_by_date.each do |revision|
        dotc_exists = DataObjectsTaxonConcept.find_by_taxon_concept_id_and_data_object_id(taxon_concept_id, revision.id)
        dotc_exists.destroy unless dotc_exists.nil?
      end
    end
  end

  def still_associated_with_taxon_concept?(taxon_concept_id)
    all_associations.each do |association|
      if association.class == UsersDataObject
        return true if association.taxon_concept_id == taxon_concept_id
      else
        return true if association.taxon_concept.id == taxon_concept_id
      end
    end
    return false
  end

  def translated_from
    data_object_translation ? data_object_translation.original_data_object : nil
  end
  alias :translation_source :translated_from

  def available_translations_data_objects(current_user, taxon)
    latest_translations = []
    # first checking if this is original, which will have translations
    unless translations.blank?
      latest_translations << self
      translations.each do |tr|
        latest_translations << tr.data_object
      end
    else
      # now checking if this is the translated form of some other original
      if data_object_translation
        original_data_object = data_object_translation.original_data_object
        latest_translations << original_data_object
        # including the other translations of the primary object
        original_data_object.translations.each do |tr|
          latest_translations << tr.data_object
        end
      end
    end
    latest_translations.map!{ |d| d.latest_published_version_in_same_language }
    latest_translations.compact!
    latest_translations.uniq!
    latest_translations.delete_if{ |d| d.language && !Language.approved_languages.include?(d.language) }
    latest_translations.delete_if{ |d| !d.published? }
    if latest_translations.length > 1
      DataObject.sort_by_language_view_order_and_label(latest_translations)
      if !taxon.nil?
        dobjs = DataObject.filter_list_for_user(latest_translations, {:user => current_user, :taxon_concept => taxon})
      end
      return latest_translations
    end
  end


  def available_translation_languages(current_user, taxon)
    dobjs = available_translations_data_objects(current_user, taxon)
    if dobjs and !dobjs.empty?
      lang_ids = []
      dobjs.each do |dobj|
        lang_ids << dobj.language_id
      end

      lang_ids = lang_ids.uniq
      if !lang_ids.empty? && lang_ids.length>1
        languages = Language.find_by_sql("SELECT * FROM languages WHERE id in (#{lang_ids.join(',')}) AND activated_on <= NOW() ORDER BY sort_order")
        if !languages.blank? && languages.length>1
          return languages
        end
      end
    end
    return nil

  end

  def log_activity_in_solr(options)
    base_index_hash = {
      'activity_log_unique_key' => "UsersDataObject_#{id}",
      'activity_log_type' => 'UsersDataObject',
      'activity_log_id' => self.users_data_object.id,
      'action_keyword' => options[:keyword],
      'date_created' => self.updated_at.solr_timestamp || self.created_at.solr_timestamp }
    base_index_hash[:user_id] = options[:user].id if options[:user]
    EOL::Solr::ActivityLog.index_notifications(base_index_hash, notification_recipient_objects(options))
    SolrLog.log_transaction($SOLR_ACTIVITY_LOGS_CORE, id, 'DataObject', 'update')
    queue_notifications
  end

  def queue_notifications
    Notification.queue_notifications(notification_recipient_objects, self)
  end

  def notification_recipient_objects(options = {})
    return @notification_recipients if @notification_recipients
    @notification_recipients = []
    add_recipient_user_making_object_modification(@notification_recipients, options)
    add_recipient_pages_affected(@notification_recipients, options)
    add_recipient_users_watching(@notification_recipients, options)
    @notification_recipients
  end

  def contributing_user
    if users_data_object && users_data_object.user
      users_data_object.user
    elsif content_partner && content_partner.user
      content_partner.user
    end
  end

  def build_relationship_to_taxon_concept_by_user(taxon_concept, user)
    DataObjectsTaxonConcept.find_or_create_by_taxon_concept_id_and_data_object_id(taxon_concept.id, self.id)
    UsersDataObject.create(:user => user, :data_object => self,
                           :taxon_concept => taxon_concept, :visibility => Visibility.visible)
  end

  def revisions_by_date
    @revisions_by_date ||= DataObject.sort_by_created_date(self.revisions).reverse
  end

  def latest_published_revision
    revisions_by_date.select {|r| r.published? }.first
  end

  def unpublish_previous_revisions
    DataObject.find(:all, :conditions => "id != #{self.id} AND guid = '#{self.guid}'").each do |dato|
      dato.update_attribute(:published, 0)
      dato.update_solr_index
    end
  end

  def reload
    @all_assoc = nil
    super
  end

  def can_be_deleted_by?(requestor)
    return false
  end

private

  def add_recipient_user_making_object_modification(recipients, options = {})
    if options[:user]
      recipients << { :user => options[:user], :notification_type => :i_created_something,
                      :frequency => NotificationFrequency.never }
      recipients << options[:user].watch_collection if options[:user].watch_collection
    end
  end
  
  def add_recipient_pages_affected(recipients, options = {})
    if options[:taxon_concept]
      recipients << options[:taxon_concept]
      recipients << { :ancestor_ids => options[:taxon_concept].flattened_ancestor_ids }
    else
      self.curated_hierarchy_entries.each do |he|
        recipients << he.taxon_concept
        recipients << { :ancestor_ids => he.taxon_concept.flattened_ancestor_ids }
      end
    end
  end
  
  def add_recipient_users_watching(recipients, options = {})
    if options[:taxon_concept]
      options[:taxon_concept].containing_collections.watch.each do |collection|
        collection.users.each do |user|
          user.add_as_recipient_if_listening_to(:new_data_on_my_watched_item, recipients)
        end
      end
    end
  end

  # NOTE - description required, and published will default to false from the DB, so you PROBABLLY want to specify it.
  def default_values # Ideally, these would be in the DB, but I didn't want to take that step.  ...yet.
    if defined?(PhusionPassenger)
      UUID.state_file(0664) # Makes the file writable, which we seem to need to do with Passenger...
    end
    self.guid ||= UUID.generate.gsub('-','')
    self.identifier ||= ''
    self.data_type_id ||= DataType.text.id
    self.mime_type_id ||= MimeType.find_by_translated(:label, 'text/plain').id
    self.location ||= ''
    self.latitude ||= 0
    self.longitude ||= 0
    self.altitude ||= 0
    self.object_url ||= ''
    self.thumbnail_url ||= ''
    self.object_title ||= ''
    self.language_id ||= Language.default.id
    self.license_id ||= License.default.id
    self.rights_statement ||= ''
    self.bibliographic_citation ||= ''
    self.source_url ||= ''
    self.data_rating ||= 2.5
  end

  def clean_values
    # Some HTML Allowed:
    self.description = Sanitize.clean(self.description.balance_tags, Sanitize::Config::RELAXED)
    # No HTML Allowed:
    self.rights_holder          = ERB::Util.h(self.rights_holder)
    self.rights_statement       = ERB::Util.h(self.rights_statement)
    self.bibliographic_citation = ERB::Util.h(self.bibliographic_citation)
    self.source_url             = ERB::Util.h(self.source_url)
  end
  
  def rights_required?
    ! license.is_public_domain?
  end

end
