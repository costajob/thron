require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ExternalId
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new(name: 'id'),
          type: Mappable::Attribute::new(name: 'externalType')
        }
      end
      include Mappable
    end
  end
end
