require_relative '../behaviour/simply_mappable'

module Thron
  module Entity
    class PrettyId
      include SimplyMappable
      self.mappings = %w[id locale]
      include Mappable
    end
  end
end
