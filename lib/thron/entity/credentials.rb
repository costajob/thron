require_relative '../behaviour/simply_mappable'

module Thron
  module Entity
    class Credentials
      include SimplyMappable
      self.mappings = %w[username password]
      include Mappable
    end
  end
end
