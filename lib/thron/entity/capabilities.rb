require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Capabilities
      def self.mappings
        @mappings ||= { 
          capabilities: Attribute::new(name: 'capabilities', type: Attribute::LIST),
          roles: Attribute::new(name: 'userRoles', type: Attribute::LIST),
          solutions: Attribute::new(name: 'enabledSolutions', type: Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
