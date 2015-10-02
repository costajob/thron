require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Picture
      def self.mappings
        @mappings ||= { 
          url: Mappable::Attribute::new(name: 'imageUrl')
        }
      end
      include Mappable
    end
  end
end
