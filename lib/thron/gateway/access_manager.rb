require_relative 'base'

module Thron
  module Gateway
    class AccessManager < Base
      def self.package
        Package.new(:xsso, :resources, self.service_name)
      end
    end
  end
end
