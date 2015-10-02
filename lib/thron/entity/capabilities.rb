require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Capabilities
      def self.mappings
        @mappings ||= { 
          capabilities: Mappable::Attribute::new(name: 'capabilities', type: Mappable::Attribute::LIST),
          roles: Mappable::Attribute::new(name: 'userRoles', type: Mappable::Attribute::LIST),
          solutions: Mappable::Attribute::new(name: 'enabledSolutions', type: Mappable::Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
