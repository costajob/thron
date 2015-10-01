require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Email
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new('emailCategory'),
          address: Mappable::Attribute::new('email')
        }
      end
      include Mappable
    end
  end
end
