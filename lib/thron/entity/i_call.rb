require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ICall
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new(name: 'inumberCategory'),
          number: Mappable::Attribute::new(name: 'inumber')
        }
      end
      include Mappable
    end
  end
end
