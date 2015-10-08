require_relative '../behaviour/simply_mappable'

module Thron
  module Entity
    class CropArea
      include SimplyMappable
      self.type = Mappable::Attribute::INT
      self.mappings = %w[x y height width]
      include Mappable
    end
  end
end
