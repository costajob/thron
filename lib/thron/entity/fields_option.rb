require_relative '../behaviour/mappable'

module Thron
  module Entity
    class FieldsOption
      def self.mappings
        @mappings ||= { 
          own_acl: Attribute::new(name: 'returnOwnAcl', type: Attribute::BOOL),
          i_tags: Attribute::new(name: 'returnItags', type: Attribute::BOOL),
          i_metadata: Attribute::new(name: 'returnImetadata', type: Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
