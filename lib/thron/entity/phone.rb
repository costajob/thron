require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Phone
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new('phoneCategory'),
          number: Mappable::Attribute::new('phoneNumber')
        }
      end
      include Mappable
    end
  end
end
