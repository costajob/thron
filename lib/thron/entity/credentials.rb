require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Credentials
      def self.mappings
        @mappings ||= { 
          username: Attribute::new(name: 'username'),
          password: Attribute::new(name: 'password')
        }
      end
      include Mappable
    end
  end
end
