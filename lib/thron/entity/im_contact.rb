require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ImContact
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new('imId'),
          type: Mappable::Attribute::new('imType')
        }
      end
      include Mappable
    end
  end
end
