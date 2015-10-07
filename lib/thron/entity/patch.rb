require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Patch 
      def self.mappings
        @mappings ||= { 
          op: Attribute::new(name: 'op'),
          field: Attribute::new(name: 'field')
        }
      end
      include Mappable
    end
  end
end
