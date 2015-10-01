require_relative '../behaviour/mappable'

module Thron
  module Entity
    class FieldsOption
      def self.mappings
        @mappings ||= { 
          own_acl: Mappable::Attribute::new('returnOwnAcl', Mappable::Attribute::BOOL),
          i_tags: Mappable::Attribute::new('returnItags', Mappable::Attribute::BOOL),
          i_metadata: Mappable::Attribute::new('returnImetadata', Mappable::Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
