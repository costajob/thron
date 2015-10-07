require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Phone
      def self.mappings
        @mappings ||= { 
          category: Attribute::new(name: 'phoneCategory'),
          number: Attribute::new(name: 'phoneNumber')
        }
      end
      include Mappable
    end
  end
end
