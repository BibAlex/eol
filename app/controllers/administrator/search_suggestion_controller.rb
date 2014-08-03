class Administrator::SearchSuggestionController < AdminController

  layout 'deprecated/left_menu'

  before_filter :set_layout_variables

  helper :resources

  before_filter :restrict_to_admins

  def index
    @page_title = I18n.t("search_suggestions")
    @term_search_string = params[:term_search_string] || ''
    search_string_parameter = '%' + @term_search_string + '%'
    # let us go back to a page where we were
    page = params[:page] || "1"
    @search_suggestions = SearchSuggestion.paginate(
      conditions: ['term like ?', search_string_parameter],
      order: 'term asc', page: page)
    SearchSuggestion.preload_associations(@search_suggestions, { taxon_concept: { preferred_entry: { hierarchy_entry: { name: :ranked_canonical_form } } } })
    @search_suggestions_count = SearchSuggestion.count(conditions: ['term like ?', search_string_parameter])
  end

  def new
    @page_title = I18n.t("new_search_suggestion")
    @search_suggestion = SearchSuggestion.new
    store_location(referred_url) if request.get?
  end

  def edit
    @page_title = I18n.t("edit_search_suggestion")
    @search_suggestion = SearchSuggestion.find(params[:id])
    store_location(referred_url) if request.get?
  end

  def create
    console.log
    @search_suggestion = SearchSuggestion.new(params[:search_suggestion])
    if @search_suggestion.save
      flash[:notice] = I18n.t(:search_suggestion_created)
      redirect_back_or_default(url_for(action: 'index'))
      @search_suggestion.update_attributes(site_id: PEER_SITE_ID, origin_id: @search_suggestion.id)
      sync_create_search_suggestion
    else
      render action: "new"
    end
  end

  def update
    @search_suggestion = SearchSuggestion.find(params[:id])
    if @search_suggestion.update_attributes(params[:search_suggestion])
      sync_update_search_suggestion
      flash[:notice] = I18n.t(:search_suggestion_updated)
      redirect_back_or_default(url_for(action: 'index'))
    else
      render action: "edit"
    end
  end

  def destroy
    (redirect_to referred_url, status: :moved_permanently;return) unless request.delete?
    @search_suggestion = SearchSuggestion.find(params[:id])
    @search_suggestion.destroy
    redirect_to referred_url, status: :moved_permanently
  end

  def set_layout_variables
    @page_title = $ADMIN_CONSOLE_TITLE
    @navigation_partial = '/admin/navigation'
  end
  
private

  def sync_create_search_suggestion
    taxon_concept = TaxonConcept.find(params[:search_suggestion][:taxon_id].to_i)
    sync_params = {taxon_concept_origin_id: taxon_concept.origin_id,
                   taxon_concept_site_id: taxon_concept.site_id}.merge(params[:search_suggestion])
    sync_params.delete(:taxon_id)
    options = {user: current_user, object: @search_suggestion, action_id: SyncObjectAction.create.id,
               type_id: SyncObjectType.search_suggestion.id, params: sync_params}
    SyncPeerLog.log_action(options)
  end
  
  def sync_update_search_suggestion
    taxon_concept = TaxonConcept.find(params[:search_suggestion][:taxon_id].to_i)
    sync_params = {taxon_concept_origin_id: taxon_concept.origin_id,
                   taxon_concept_site_id: taxon_concept.site_id}.merge(params[:search_suggestion])
    sync_params.delete(:taxon_id)
    options = {user: current_user, object: @search_suggestion, action_id: SyncObjectAction.update.id,
               type_id: SyncObjectType.search_suggestion.id, params: sync_params}
    SyncPeerLog.log_action(options)
  end
end
