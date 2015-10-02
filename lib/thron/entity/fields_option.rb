require_relative '../behaviour/mappable'

module Thron
  module Entity
    class FieldsOption
      def self.mappings
        @mappings ||= { 
          own_acl: Mappable::Attribute::new(name: 'returnOwnAcl', type: Mappable::Attribute::BOOL),
          i_tags: Mappable::Attribute::new(name: 'returnItags', type: Mappable::Attribute::BOOL),
          i_metadata: Mappable::Attribute::new(name: 'returnImetadata', type: Mappable::Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
