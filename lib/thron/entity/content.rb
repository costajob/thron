require_relative 'score'
require_relative 'delivery_info'
require_relative 'category'
require_relative 'tag'
require_relative 'i_tag'
require_relative 'i_metadata'
require_relative 'provider'
require_relative 'embed_code'
require_relative 'counter'
require_relative 'weebo'

module Thron
  module Entity
    class Content
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'id'),
          status: Attribute::new(name: 'status'),
          version: Attribute::new(name: 'version', type: Attribute::INT),
          type: Attribute::new(name: 'contentType'),
          user_id: Attribute::new(name: 'userId'),
          solution: Attribute::new(name: 'solution'),
          p_version: Attribute::new(name: 'pcontentVersion', type: Attribute::INT),
          dyn_thumb_service: Attribute::new(name: 'dynThumbService'),
          owner: Attribute::new(name: 'owner'),
          providers: Attribute::new(name: 'providers', type: [Provider]),
          created_at: Attribute::new(name: 'creationDate', type: Attribute::TIME),
          updated_at: Attribute::new(name: 'lastUpdate', type: Attribute::TIME),
          locales: Attribute::new(name: 'locales', type: [Locale]),
          embed_codes: Attribute::new(name: 'embedCodes', type: [EmbedCode]),
          pretty_ids: Attribute::new(name: 'prettyIds', type: [PrettyId]),
          counter: Attribute::new(name: 'viewCounter', type: Counter),
          weebo: Attribute::new(name: 'weebo', type: Weebo),
          ugc_content: Attribute::new(name: 'contentUGC', type: Attribute::BOOL),
          in_solutions: Attribute::new(name: 'availableInSolutions', type: Attribute::LIST),
          properties: Attribute::new(name: 'properties', type: Attribute::LIST),
          score: Attribute::new(name: 'score', type: Score),
          delivery_info: Attribute::new(name: 'deliveryInfo', type: [DeliveryInfo]),
          ratings_count: Attribute::new(name: 'ratingCounter', type: Attribute::INT),
          comments_count: Attribute::new(name: 'commentsCounter', type: Attribute::INT),
          approved_comments_count: Attribute::new(name: 'commentsApprovedCounter', type: Attribute::INT),
          last_updated_comment: Attribute::new(name: 'lastUpdatedComment'),
          inactive_since: Attribute::new(name: 'inactiveDate', type: Attribute::INT),
          sorted_by: Attribute::new(name: 'sortingField', type: Attribute::INT),
          metadata: Attribute::new(name: 'metadatas', type: [Metadata]),
          tags: Attribute::new(name: 'tags', type: [Tag]),
          i_metadata: Attribute::new(name: 'imetadata', type: [IMetadata]),
          i_tags: Attribute::new(name: 'itags', type: [ITag]),
          linked_contents: Attribute::new(name: 'linkedContents', type: [Content]),
          linked_categories: Attribute::new(name: 'linkedCategories', type: [Category]),
        }
      end
      include Mappable
    end
  end
end
