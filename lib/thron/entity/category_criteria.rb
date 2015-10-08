require_relative 'metadata'
require_relative 'acl'

module Thron
  module Entity
    class CategoryCriteria
      def self.mappings
        @mappings ||= { 
          ids: Attribute::new(name: 'categoryIds', type: Attribute::LIST),
          name: Attribute::new(name: 'name'),
          locale: Attribute::new(name: 'locale'),
          metadata: Attribute::new(name: 'metadatas', type: [Metadata]),
          solution: Attribute::new(name: 'solution'),
          keyword: Attribute::new(name: 'textSearch'),
          types: Attribute::new(name: 'categoryTypes', type: Attribute::LIST),
          parent: Attribute::new(name: 'childOf'),
          limit_level: Attribute::new(name: 'excludeLevelHigherThan', type: Attribute::INT),
          solutions: Attribute::new(name: 'availableInSolutions', type: Attribute::LIST),
          acl: Attribute::new(name: 'acl', type: Acl)
        }
      end
      include Mappable
    end
  end
end
