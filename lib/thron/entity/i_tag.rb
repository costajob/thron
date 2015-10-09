require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ITag
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'id'),
          clasification_id: Attribute::new(name: 'classificationId'),
          approved: Attribute::new(name: 'approved', type: Attribute::BOOL),
          sources: Attribute::new(name: 'sources', type: [:Plain])
        }
      end
      include Mappable
    end
  end
end
