require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Patch 
      def self.mappings
        @mappings ||= { 
          op: Mappable::Attribute::new(name: 'op'),
          field: Mappable::Attribute::new(name: 'field')
        }
      end
      include Mappable
    end
  end
end
