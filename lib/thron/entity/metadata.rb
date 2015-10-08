require_relative 'base'

module Thron
  module Entity
    class Metadata < Base
      self.mappings = %w[name value locale]
      include Mappable
    end
  end
end
