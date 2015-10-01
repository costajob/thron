require_relative 'source'

module Thron
  module Entity
    class ITag
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new('id'),
          clasification_id: Mappable::Attribute::new('classificationId'),
          approved: Mappable::Attribute::new('approved', Mappable::Attribute::BOOL),
          sources: Mappable::Attribute::new('sources', [Source])
        }
      end
      include Mappable
    end
  end
end
