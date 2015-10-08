require_relative '../behaviour/simply_mappable'

module Thron
  module Entity
    class Metadata
      include SimplyMappable
      self.mappings = %w[name value locale]
      include Mappable
    end
  end
end
