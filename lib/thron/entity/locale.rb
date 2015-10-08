require_relative 'base'

module Thron
  module Entity
    class Locale < Base
      self.mappings = %w[name description locale excerpt]
      include Mappable
    end
  end
end
