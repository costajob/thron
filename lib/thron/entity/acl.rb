require_relative 'acl_rule'

module Thron
  module Entity
    class Acl
      def self.mappings
        @mappings ||= { 
          on_context: Attribute::new(name: 'onContext'),
          rules: Attribute::new(name: 'rules', type: [AclRule])
        }
      end
      include Mappable
    end
  end
end
