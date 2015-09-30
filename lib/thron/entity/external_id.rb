require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ExternalId
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new('id'),
          type: Mappable::Attribute::new('externalType')
        }
      end
      include Mappable
    end
  end
end
