require_relative '../behaviour/mappable'

module Thron
  module Entity
    class AclRule
      def self.mappings
        @mappings ||= { 
          target_id: Attribute::new(name: 'targetObjId'),
          target_class: Attribute::new(name: 'targetObjClass'),
          enabled: Attribute::new(name: 'rules', type: Attribute::LIST),
          disabled: Attribute::new(name: 'disabledRules', type: Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
