require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Source
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new(name: 'id'),
          type: Mappable::Attribute::new(name: 'stype')
        }
      end
      include Mappable
    end
  end
end
