require_relative '../behaviour/simply_mappable'

module Thron
  module Entity
    class Locale
      include SimplyMappable
      self.mappings = %w[name description locale excerpt]
      include Mappable
    end
  end
end
