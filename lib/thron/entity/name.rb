require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Name
      def self.mappings
        @mappings ||= { 
          prefix: Mappable::Attribute::new('prefix'),
          first: Mappable::Attribute::new('firstName'),
          middle: Mappable::Attribute::new('middleName'),
          last: Mappable::Attribute::new('lastName'),
          suffix: Mappable::Attribute::new('suffix')
        }
      end
      include Mappable
    end
  end
end
