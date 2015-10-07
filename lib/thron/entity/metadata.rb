require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Metadata
      def self.mappings
        @mappings ||= { 
          name: Attribute::new(name: 'name'),
          value: Attribute::new(name: 'value')
        }
      end
      include Mappable
    end
  end
end
