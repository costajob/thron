require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ImContact
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'imId'),
          type: Attribute::new(name: 'imType')
        }
      end
      include Mappable
    end
  end
end
