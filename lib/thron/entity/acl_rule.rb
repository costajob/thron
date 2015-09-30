require_relative '../behaviour/mappable'

module Thron
  module Entity
    class AclRule
      def self.mappings
        @mappings ||= { 
          target_id: 'targetObjId',
          target_class: 'targetObjClass',
          enabled: 'rules',
          disabled: 'disabledRules'
        }
      end
      include Mappable
    end
  end
end
