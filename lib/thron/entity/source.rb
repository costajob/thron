require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Source
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new('id'),
          type: Mappable::Attribute::new('stype')
        }
      end
      include Mappable
    end
  end
end
