require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Email
      def self.mappings
        @mappings ||= { 
          category: Attribute::new(name: 'emailCategory'),
          address: Attribute::new(name: 'email')
        }
      end
      include Mappable
    end
  end
end
