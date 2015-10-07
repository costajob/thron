require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Name
      def self.mappings
        @mappings ||= { 
          prefix: Attribute::new(name: 'prefix'),
          first: Attribute::new(name: 'firstName'),
          middle: Attribute::new(name: 'middleName'),
          last: Attribute::new(name: 'lastName'),
          suffix: Attribute::new(name: 'suffix')
        }
      end
      include Mappable
    end
  end
end
