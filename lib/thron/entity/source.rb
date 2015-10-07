require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Source
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'id'),
          type: Attribute::new(name: 'stype')
        }
      end
      include Mappable
    end
  end
end
