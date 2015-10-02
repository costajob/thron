require_relative '../behaviour/mappable'

module Thron
  module Entity
    class AclRule
      def self.mappings
        @mappings ||= { 
          target_id: Mappable::Attribute::new(name: 'targetObjId'),
          target_class: Mappable::Attribute::new(name: 'targetObjClass'),
          enabled: Mappable::Attribute::new(name: 'rules', type: Mappable::Attribute::LIST),
          disabled: Mappable::Attribute::new(name: 'disabledRules', type: Mappable::Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
