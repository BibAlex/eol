class Taxa::NamesController < TaxaController

  before_filter :instantiate_taxon_concept
  before_filter :set_vet_options, :only => [:common_names, :vet_common_name]
  before_filter :authentication_for_names, :only => [ :create, :update ]
  before_filter :preload_core_relationships_for_names, :only => [ :index, :common_names, :synonyms ]

  # GET /pages/:taxon_id/names
  # related names default tab
  def index
    if @selected_hierarchy_entry
      @related_names = TaxonConcept.related_names(:hierarchy_entry_id => @selected_hierarchy_entry_id)
    else
      @related_names = TaxonConcept.related_names(:taxon_concept_id => @taxon_concept.id)
    end
    @assistive_section_header = I18n.t(:assistive_names_related_header)
    current_user.log_activity(:viewed_taxon_concept_names_related_names, :taxon_concept_id => @taxon_concept.id)

    # for common names count
    common_names_count
  end

  # POST /pages/:taxon_id/names currently only used to add common_names
  def create
    if params[:commit_add_common_name]
      agent = current_user.agent
      language = Language.find(params[:name][:synonym][:language_id])
      synonym = @taxon_concept.add_common_name_synonym(params[:name][:string],
                  :agent => agent, :language => language, :vetted => Vetted.trusted)
      log_action(@taxon_concept, synonym, :add_common_name)
      expire_taxa([@taxon_concept.id])
    end
    store_location params[:return_to] unless params[:return_to].blank?
    redirect_back_or_default common_names_taxon_names_path(@taxon_concept)
  end

  # PUT /pages/:taxon_id/names currently only used to update common_names
  def update
    # TODO:
  end


  # GET for collection synonyms /pages/:taxon_id/synonyms
  def synonyms
    associations = { :published_hierarchy_entries => [ :name, { :scientific_synonyms => [ :synonym_relation, :name ] } ] }
    options = { :select => { :hierarchy_entries => [ :id, :name_id, :hierarchy_id, :taxon_concept_id ],
                           :names => [ :id, :string ],
                           :synonym_relations => [ :id ] } }
    TaxonConcept.preload_associations(@taxon_concept, associations, options )
    @assistive_section_header = I18n.t(:assistive_names_synonyms_header)
    current_user.log_activity(:viewed_taxon_concept_names_synonyms, :taxon_concept_id => @taxon_concept.id)

    # for common names count
    common_names_count
  end

  # GET for collection common_names /pages/:taxon_id/names/common_names
  def common_names
    @languages = Language.with_iso_639_1.sort_by{ |l| l.label }
    @languages.collect! {|lang|  [lang.label.to_s.truncate(20), lang.id] }
    @common_names = get_common_names
    @common_names_count = @common_names.count
    @assistive_section_header = I18n.t(:assistive_names_common_header)
    current_user.log_activity(:viewed_taxon_concept_names_common_names, :taxon_concept_id => @taxon_concept.id)
  end

  # TODO - This needs to add a CuratorActivityLog.
  def vet_common_name
    language_id = params[:language_id].to_i
    name_id = params[:id].to_i
    vetted = Vetted.find(params[:vetted_id])
    @taxon_concept.current_user = current_user
    @taxon_concept.vet_common_name(:language_id => language_id, :name_id => name_id, :vetted => vetted)
    current_user.log_activity(:vetted_common_name, :taxon_concept_id => @taxon_concept.id, :value => name_id)
    respond_to do |format|
      format.html do
        if !params[:hierarchy_entry_id].blank?
          redirect_to common_names_taxon_hierarchy_entry_names_path(@taxon_concept, params[:hierarchy_entry_id])
        else
          redirect_to common_names_taxon_names_path(@taxon_concept)
        end
      end
      format.js do
        # TODO - this is a huge waste of time, but I couldn't come up with a timely solution... we only need ONE set
        # of names, here, not all of them:
        render :partial => 'common_names_edit_row', :locals => {:common_names => get_common_names,
          :language => TranslatedLanguage.find(language_id).label, :name_id => name_id }
      end
    end
  end

private

  def get_common_names
    if @selected_hierarchy_entry
      names = @taxon_concept.common_names(:hierarchy_entry_id => @selected_hierarchy_entry.id)
    else
      names = @taxon_concept.common_names
    end
  end

  def common_names_count
    @common_names_count = get_common_names.count if @common_names_count.nil?
    @common_names_count
  end

  def set_vet_options
    @common_name_vet_options = {I18n.t(:trusted) => Vetted.trusted.id.to_s, I18n.t(:unreviewed) => Vetted.unknown.id.to_s, I18n.t(:untrusted) => Vetted.untrusted.id.to_s, I18n.t(:inappropriate) => Vetted.inappropriate.id.to_s}
  end

  def preload_core_relationships_for_names
    selects = {
      :taxon_concepts => '*',
      :hierarchy_entries => [ :id, :rank_id, :identifier, :hierarchy_id, :parent_id, :published,
                              :visibility_id, :lft, :rgt, :taxon_concept_id, :source_url ],
      :names => [ :string, :italicized, :canonical_form_id, :ranked_canonical_form_id ],
      :hierarchies => [ :agent_id, :browsable, :outlink_uri, :label ],
      :hierarchies_content => [ :content_level, :image, :text, :child_image, :map, :youtube, :flash ],
      :vetted => :view_order,
      :agents => '*' }
    @taxon_concept = TaxonConcept.core_relationships(:select => selects).find_by_id(@taxon_concept.id)
    if @selected_hierarchy_entry.blank?
      @hierarchy_entries = @taxon_concept.published_browsable_hierarchy_entries
    else
      @hierarchy_entries =
        @taxon_concept.published_browsable_hierarchy_entries.select {|he| he.id == @selected_hierarchy_entry.id}
    end
  end

  def authentication_for_names
    if ! current_user.is_curator?
      flash[:error] = I18n.t(:insufficient_privileges_to_curate_names)
      store_location params[:return_to] unless params[:return_to].blank?
      redirect_back_or_default common_names_taxon_names_path(@taxon_concept)
    end
  end

end
