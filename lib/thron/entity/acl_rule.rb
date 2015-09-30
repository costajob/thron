require_relative '../behaviour/mappable'

module Thron
  module Entity
    class AclRule
      def self.mappings
        @mappings ||= { 
          target_id: Mappable::Attribute::new('targetObjId'),
          target_class: Mappable::Attribute::new('targetObjClass'),
          enabled: Mappable::Attribute::new('rules', Mappable::Attribute::LIST),
          disabled: Mappable::Attribute::new('disabledRules', Mappable::Attribute::LIST)
        }
      end
      include Mappable
    end
  end
end
