require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Patch 
      def self.mappings
        @mappings ||= { 
          op: Mappable::Attribute::new('op'),
          field: Mappable::Attribute::new('field')
        }
      end
      include Mappable
    end
  end
end
