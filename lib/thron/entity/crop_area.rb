require_relative 'base'

module Thron
  module Entity
    class CropArea < Base
      self.type = Mappable::Attribute::INT
      self.mappings = %w[x y height width]
      include Mappable
    end
  end
end
