require_relative 'base'

module Thron
  module Entity
    class Credentials < Base
      self.mappings = %w[username password]
      include Mappable
    end
  end
end
