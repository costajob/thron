require_relative 'pretty_id'
require_relative 'metadata'
require_relative 'locale'

module Thron
  module Entity
    class Category
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'id'),
          pretty_ids: Attribute::new(name: 'prettyIds', type: [PrettyId]),
          up_category_id: Attribute::new(name: 'upCategoryId'),
          solution: Attribute::new(name: 'solution'),
          in_solutions: Attribute::new(name: 'availableInSolutions', type: Attribute::LIST),
          active: Attribute::new(name: 'active', type: Attribute::BOOL),
          ancestors_ids: Attribute::new(name: 'ancestorIds', type: Attribute::LIST),
          user_id: Attribute::new(name: 'userId'),
          type: Attribute::new(name: 'categoryType'),
          metadata: Attribute::new(name: 'metadatas', type: [Metadata]),
          created_at: Attribute::new(name: 'creationDate', type: Attribute::TIME),
          sorted_by: Attribute::new(name: 'sortingField'),
          version: Attribute::new(name: 'version', type: Attribute::INT),
          locales: Attribute::new(name: 'locales', type: [Locale]),
          linked_categories: Attribute::new(name: 'linkedCategories', type: Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
