xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8", :standalone => "yes"

xml.response do
  
  unless @collection.blank?
    xml.name @collection.name
    xml.description @collection.description
    xml.logo_url @collection.logo_cache_url.blank? ? nil : @collection.logo_url
    xml.created @collection.created_at
    xml.modified @collection.updated_at
    xml.total_items @collection_results.total_entries
    
    xml.item_types do
      ['TaxonConcept', 'Text', 'Video', 'Image', 'Sound', 'Community', 'User', 'Collection'].each do |facet|
        xml.item_type do
          xml.label facet
          xml.item_count @facet_counts[facet] || 0
        end
      end
    end
    
    # NOTE - Not changing the XML response, here, so it still uses object_id and object_type. Hmmmn...
    xml.collection_items do
      @collection_results.each do |r|
        xml.item do
          ci = r['instance']
          collected_item_type = ci.collected_item_type
          xml.name r['title']
          xml.object_id ci.collected_item_id
          xml.title ci.name
          xml.created ci.created_at
          xml.updated ci.updated_at
          xml.annotation ci.annotation
          xml.sort_field ci.sort_field
          if @collection.show_references?
            xml.references do 
              ci.refs.each do |ref|
                xml.reference ref.full_reference
              end
            end
          end

          case ci.collected_item_type
          when 'TaxonConcept'
            xml.richness_score r['richness_score']
            # xml.taxonRank ci.collected_item.entry.rank.label.firstcap unless ci.collected_item.entry.rank.nil?
          when 'DataObject'
            xml.data_rating r['data_rating']
            xml.object_guid ci.collected_item.guid
            collected_item_type = ci.collected_item.data_type.simple_type
            if ci.collected_item.is_image?
              xml.source ci.collected_item.thumb_or_object(:orig)
            end
          end
          
          xml.object_type collected_item_type
        end
      end
    end
    
  end
end
