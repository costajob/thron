require_relative 'base'

module Thron
  module Entity
    class PrettyId < Base
      self.mappings = %w[id locale]
      include Mappable
    end
  end
end
