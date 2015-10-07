require_relative '../behaviour/mappable'

module Thron
  module Entity
    class CropArea
      def self.mappings
        @mappings ||= { 
          x: Attribute::new(name: 'x', type: Attribute::INT),
          y: Attribute::new(name: 'y', type: Attribute::INT),
          height: Attribute::new(name: 'height', type: Attribute::INT),
          width: Attribute::new(name: 'width', type: Attribute::INT)
        }
      end
      include Mappable
    end
  end
end
