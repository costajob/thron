require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Credentials
      def self.mappings
        @mappings ||= { 
          username: Mappable::Attribute::new(name: 'username'),
          password: Mappable::Attribute::new(name: 'password')
        }
      end
      include Mappable
    end
  end
end
