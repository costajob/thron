require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Metadata
      def self.mappings
        @mappings ||= { 
          name: Mappable::Attribute::new(name: 'name'),
          value: Mappable::Attribute::new(name: 'value')
        }
      end
      include Mappable
    end
  end
end
