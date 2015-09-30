require_relative '../behaviour/mappable'

module Thron
  module Entity
    class FieldsOption
      def self.mappings
        @mappings ||= { 
          own_acl: Mappable::Attribute::new('returnOwnAcl', Mappable::Attribute::BOOL),
          itags: Mappable::Attribute::new('returnItags', Mappable::Attribute::BOOL),
          imetadata: Mappable::Attribute::new('returnImetadata', Mappable::Attribute::BOOL),
        }
      end
      include Mappable
    end
  end
end
