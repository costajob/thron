require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Name
      def self.mappings
        @mappings ||= { 
          prefix: Mappable::Attribute::new(name: 'prefix'),
          first: Mappable::Attribute::new(name: 'firstName'),
          middle: Mappable::Attribute::new(name: 'middleName'),
          last: Mappable::Attribute::new(name: 'lastName'),
          suffix: Mappable::Attribute::new(name: 'suffix')
        }
      end
      include Mappable
    end
  end
end
