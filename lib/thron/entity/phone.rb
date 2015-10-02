require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Phone
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new(name: 'phoneCategory'),
          number: Mappable::Attribute::new(name: 'phoneNumber')
        }
      end
      include Mappable
    end
  end
end
