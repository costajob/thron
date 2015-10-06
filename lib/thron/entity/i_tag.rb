require_relative 'source'

module Thron
  module Entity
    class ITag
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new(name: 'id'),
          clasification_id: Mappable::Attribute::new(name: 'classificationId'),
          approved: Mappable::Attribute::new(name: 'approved', type: Mappable::Attribute::BOOL),
          sources: Mappable::Attribute::new(name: 'sources', type: [Source]),
          stypes: Mappable::Attribute::new(name: 'stypes', type: Mappable::Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
