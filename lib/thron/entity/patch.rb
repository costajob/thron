require_relative 'base'

module Thron
  module Entity
    class Patch < Base 
      self.mappings = %w[op field]
      include Mappable
    end
  end
end
