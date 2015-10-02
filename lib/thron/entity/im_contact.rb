require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ImContact
      def self.mappings
        @mappings ||= { 
          id: Mappable::Attribute::new(name: 'imId'),
          type: Mappable::Attribute::new(name: 'imType')
        }
      end
      include Mappable
    end
  end
end
