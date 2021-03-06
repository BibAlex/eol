# Alternative names for a hierarchy entry, as provided by a specific agent.  There can be many such synonyms related to a
# hierarchy entry, but only one of them should be marked as "preferred".
class Synonym < ActiveRecord::Base
  extend SiteSpecific
  
  belongs_to :hierarchy
  belongs_to :hierarchy_entry
  belongs_to :language
  belongs_to :name
  belongs_to :synonym_relation
  belongs_to :vetted

  has_one  :taxon_concept_name
  has_many :agents_synonyms
  has_many :agents, through: :agents_synonyms
  has_many :agents_synonyms

  before_save :set_preferred
  after_update :update_taxon_concept_name
  after_create :create_taxon_concept_name
  before_destroy :set_preferred_true_for_last_synonym

  validates_uniqueness_of :name_id, scope: [:synonym_relation_id, :language_id, :hierarchy_entry_id, :hierarchy_id]

  def self.sort_by_language_and_name(synonyms)
    synonyms.sort_by do |syn|
      language_code = syn.language.blank? ? '' : syn.language.iso_639_1
      [language_code,
       name.string]
    end
  end

  def self.by_taxon(taxon_id)
    return Synonym.find_all_by_hierarchy_entry_id(taxon_id, include: [:synonym_relation, :name])
  end

  def self.generate_from_name(name_obj, options = {})
    language  = options[:language] || Language.unknown
    relation  = options[:relation] || SynonymRelation.synonym
    agent     = options[:agent]
    hierarchy = Hierarchy.eol_contributors
    preferred = options[:preferred] || 0
    vetted    = options[:vetted] || Vetted.unknown
    entry     = options[:entry]
    site_id   = options[:site_id]
    date      = options[:date]
    is_preferred = options[:is_preferred]
    raise("Cannot generate a Synonym without an :entry") unless entry
    synonym = Synonym.find_by_hierarchy_id_and_hierarchy_entry_id_and_language_id_and_name_id_and_synonym_relation_id(
              hierarchy.id, entry.id, language.id, name_obj.id, relation.id)
    if options[:preferred] # They MUST have specified this in order to run this block:
      if synonym
        if date && synonym.last_change &&synonym.last_change > date
          #save current state as it is newer
          return synonym
        end
        # set preferred common name
        synonym.preferred = preferred
        synonym.last_change = Time.now
        synonym.last_change = date if date
        synonym.save!
        # if it is comming from pull then set it manually 
        unless is_preferred.nil?
          synonym = Synonym.find_by_hierarchy_id_and_hierarchy_entry_id_and_language_id_and_name_id_and_synonym_relation_id(
                        hierarchy.id, entry.id, language.id, name_obj.id, relation.id)
          synonym.update_column(:preferred, is_preferred)
          synonym.taxon_concept_name.update_column(:preferred, is_preferred)
        end
      end
    else
      date = Time.now unless date
      # add common name
      synonym = Synonym.create(name_id: name_obj.id,
                               hierarchy_id: hierarchy.id,
                               hierarchy_entry_id: entry.id,
                               language_id: language.id,
                               synonym_relation_id: relation.id,
                               vetted: vetted,
                               preferred: preferred,
                               published: 1,
                               site_id: site_id)
      if synonym && synonym.errors.blank?
        if site_id == PEER_SITE_ID
          synonym.update_column(:origin_id, synonym.id)
        else
          synonym.update_column(:origin_id, options[:origin_id])
        end
        AgentsSynonym.create(agent_id: agent.id,
                                  agent_role_id: TranslatedAgentRole.find_by_label("Contributor").agent_role_id,
                                  synonym_id: synonym.id,
                                  view_order: 1)
      end
    end
    synonym = Synonym.find_by_hierarchy_id_and_hierarchy_entry_id_and_language_id_and_name_id_and_synonym_relation_id(
                  hierarchy.id, entry.id, language.id, name_obj.id, relation.id)
    synonym
  end

  def agents_roles
    agents_roles = []

    # its possible that the hierarchy is not associated with an agent
    if h_agent = hierarchy.agent
      h_agent.full_name = hierarchy.label # To change the name from just "Catalogue of Life"
      role = AgentRole.find_by_translated(:label, 'Source')
      agents_roles << AgentsSynonym.new(synonym: self, agent: h_agent, agent_role: role, view_order: 0)
    end
    agents_roles += agents_synonyms
  end

  # TODO - is this being used?
  def vet(vet_obj, by_whom)
    update_attributes!(vetted: vet_obj)
  end

private

  def set_preferred
    tc_id = hierarchy_entry.taxon_concept_id
    count = TaxonConceptName.find_all_by_taxon_concept_id_and_language_id(tc_id, language_id).length
    if count == 0  # this is the first name in this language for the concept
      self.preferred = 1
    # only reset other names to preferred=0 when this name is preferred and from the EOL curators hierarchy
    elsif self.preferred? && Hierarchy.eol_contributors && self.hierarchy_id == Hierarchy.eol_contributors.id
      Synonym.connection.execute("UPDATE synonyms SET preferred = 0 where hierarchy_entry_id = #{hierarchy_entry_id} and  language_id = #{language_id}")
      TaxonConceptName.connection.execute("UPDATE taxon_concept_names set preferred = 0 where taxon_concept_id = #{tc_id} and  language_id = #{language_id}")
    end
    self.preferred = 0 if Language.unknown && language_id == Language.unknown.id
  end

  def update_taxon_concept_name
    if self.preferred_changed? && self.preferred?
      TaxonConceptName.connection.execute("UPDATE taxon_concept_names set preferred = 1 where synonym_id = #{id}")
    end
    if self.vetted_id_changed?
      TaxonConceptName.connection.execute("UPDATE taxon_concept_names set vetted_id = #{vetted_id} where synonym_id = #{id}")
    end
  end

  def create_taxon_concept_name
    if Language.scientific
      vern = (language_id == 0 or language_id == Language.scientific.id) ? false : true
    else
      vern = (language_id == 0 ) ? false : true
    end
    if tcn = TaxonConceptName.find(:first, conditions: {
      taxon_concept_id: hierarchy_entry.taxon_concept_id,
      name_id: name_id,
      source_hierarchy_entry_id: hierarchy_entry_id,
      synonym_id: self.id,
      language_id: language_id })
      tcn.preferred = self.preferred
      tcn.vetted_id = vetted_id
      tcn.vern = vern
      tcn.save
    else
      TaxonConceptName.create(synonym_id: id,
        language_id: language_id,
        name_id: name_id,
        preferred: self.preferred,
        source_hierarchy_entry_id: hierarchy_entry_id,
        synonym_id: self.id,
        taxon_concept_id: hierarchy_entry.taxon_concept_id,
        vetted_id: vetted_id,
        vern: vern)
    end
  end

  def set_preferred_true_for_last_synonym
    tc_id = hierarchy_entry.taxon_concept_id
    TaxonConceptName.delete_all(synonym_id: self.id)
    AgentsSynonym.delete_all(synonym_id: self.id)
    count = TaxonConceptName.find_all_by_taxon_concept_id_and_language_id(tc_id, language_id).length
    if count == 1 and language_id != Language.unknown.id  # this is the first name in this language for the concept and lang is known
      TaxonConceptName.connection.execute("UPDATE taxon_concept_names set preferred = 1 where taxon_concept_id = #{tc_id} and  language_id = #{language_id}")
    end
  end

end
