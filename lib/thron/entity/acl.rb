require_relative 'acl_rule'

module Thron
  module Entity
    class Acl
      def self.mappings
        @mappings ||= { 
          on_context: Mappable::Attribute::new('onContext'),
          rules: Mappable::Attribute::new('rules', [AclRule])
        }
      end
      include Mappable
    end
  end
end
