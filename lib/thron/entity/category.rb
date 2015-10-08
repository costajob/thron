require_relative 'pretty_id'
require_relative 'metadata'
require_relative 'locale'
require_relative 'user_values'

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
          linked_categories: Attribute::new(name: 'linkedCategories', type: Attribute::LIST),
          user_values: Attribute::new(name: 'userSpecificValues', type: UserValues),
          contents_count: Attribute::new(name: 'numberOfContents', type: Attribute::INT),
          unread_contents_count: Attribute::new(name: 'numberOfUnreadContents', type: Attribute::INT),
          unread_nested_contents_count: Attribute::new(name: 'numberOfUnreadContentsInSubCategories', type: Attribute::INT),
          subcategories_count: Attribute::new(name: 'numberOfSubCategories', type: Attribute::INT),
          owner: Attribute::new(name: 'ownerFullname')
        }
      end
      include Mappable
    end
  end
end
