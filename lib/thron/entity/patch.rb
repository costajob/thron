require_relative '../behaviour/simply_mappable'

module Thron
  module Entity
    class Patch
      include SimplyMappable
      self.mappings = %w[op field]
      include Mappable
    end
  end
end
