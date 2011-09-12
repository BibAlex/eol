class TaxonConceptName < SpeciesSchemaModel

  set_primary_keys :taxon_concept_id, :name_id, :source_hierarchy_entry_id, :language_id

  belongs_to :language
  belongs_to :name
  belongs_to :synonym
  belongs_to :taxon_concept
  belongs_to :vetted

  def self.sort_by_language_and_name(taxon_concept_names)
    taxon_concept_names.sort_by do |tcn|
      language_iso = tcn.language.blank? ? '' : tcn.language.iso_639_1
      [language_iso,
       tcn.preferred * -1,
       tcn.name.string]
    end
  end

  def vet(vet_obj, by_whom)
    raw_update_attribute(:vetted_id, vet_obj.id)
    synonym.update_attributes!(:vetted => vet_obj) if synonym # There *are* TCNs in prod w/o synonyms (from CoL, I think)
  end

  # Our composite primary keys gem is too stupid to handle this change correctly, so we're bypassing it here:
  def raw_update_attribute(key, val)
    raise "Invalid key" unless self.respond_to? key
    TaxonConceptName.connection.execute(ActiveRecord::Base.sanitize_sql_array([%Q{
      UPDATE `#{self.class.table_name}`
      SET `#{key}` = ?
      WHERE name_id = ?
        AND taxon_concept_id = ?
        AND source_hierarchy_entry_id = ?
    }, val, self[:name_id], self[:taxon_concept_id], self[:source_hierarchy_entry_id]]))
  end

  def synonym_ids
    @synonym_ids ||= [self.synonym_id]
  end

  def self.group_and_merge_names(names)
    # @default_source = Agent.find($AGENT_ID_OF_DEFAULT_COMMON_NAME_SOURCE).full_name rescue nil
    new_names = []
    previous = nil
    names.sort.each do |name|
      if previous
        if previous === name
          new_names.last.merge!(name)
        else
          # new_names.last.sources = @default_source.to_a if new_names.last.sources.empty? # default source if one doesn't exist
          new_names << name
        end
      else # this is the first one.
        new_names << name
      end
      previous = name
    end
    new_names
  end

  def merge!(other)
    unless other.sources.to_a == ["Encyclopedia of Life"] || other.sources.nil?
      name_sources = []
      if self.sources.to_a == ["Encyclopedia of Life"] || self.sources.nil?
        self.added_by_curator = other.added_by_curator.to_i
        name_sources = other.sources.to_a
      else
        if self.added_by_curator == 0
          if other.added_by_curator.to_i == 0
            name_sources = self.sources.to_a + other.sources.to_a
          else
            name_sources = self.sources.to_a
          end
        else
          if other.added_by_curator.to_i == 0
            self.added_by_curator = 0
            name_sources = other.sources.to_a
          else
            name_sources = self.sources.to_a + other.sources.to_a
          end
        end
      end
      self.sources = name_sources.compact.uniq
    end
    self.sources
  end

  def <=>(other)
    if self.language.label == other.language.label
      if self.common_name == other.common_name
          self.vetted_id <=> other.vetted_id
      else
        self.common_name <=> other.common_name
      end
    else
      self.language.label.to_s <=> other.language.label.to_s
    end
  end

  def ===(other)
    self.language.label == other.language.label && self.name_id == other.name_id
  end
end
