require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Capabilities
      def self.mappings
        @mappings ||= { 
          capabilities: Mappable::Attribute::new('capabilities', Mappable::Attribute::LIST),
          roles: Mappable::Attribute::new('userRoles', Mappable::Attribute::LIST),
          solutions: Mappable::Attribute::new('enabledSolutions', Mappable::Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
