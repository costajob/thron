require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Credentials
      def self.mappings
        @mappings ||= { 
          username: Mappable::Attribute::new('username'),
          password: Mappable::Attribute::new('password')
        }
      end
      include Mappable
    end
  end
end
