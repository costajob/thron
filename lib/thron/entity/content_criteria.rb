require_relative 'metadata'

module Thron
  module Entity
    class ContentCriteria
      def self.mappings
        @mappings ||= { 
          locale: Attribute::new(name: 'locale'),
          category_id: Attribute::new(name: 'categoryId'),
          recursive: Attribute::new(name: 'searchOnSubCategories', type: Attribute::BOOL),
          ids: Attribute::new(name: 'xcontentIds', type: Attribute::LIST),
          type: Attribute::new(name: 'contentType'),
          channel: Attribute::new(name: 'channelType'),
          keyword: Attribute::new(name: 'searchKey'),
          tags: Attribute::new(name: 'tags', type: Attribute::LIST),
          metadata: Attribute::new(name: 'metadata', type: [Metadata]),
          solution: Attribute::new(name: 'availableInSolution'),
          active: Attribute::new(name: 'onlyActiveContents', type: Attribute::BOOL),
          ugc: Attribute::new(name: 'ugc', type: Attribute::BOOL),
          user_agent: Attribute::new(name: 'userAgent'),
          thumb_crop_area: Attribute::new(name: 'divArea')
        }
      end
      include Mappable
    end
  end
end
