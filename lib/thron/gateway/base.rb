require 'httparty'
require_relative '../config'
require_relative '../behaviour/routable'
require_relative '../behaviour/parallelizable'

module Thron
  module Gateway
    Package = Struct::new(:name, :domain, :service) do
      def to_s
        "#{name}/#{domain}/#{service}"
      end
    end

    class Base
      include Routable
      include Parallelizable

      class NoentRouteError < StandardError; end
      
      def self.service_name
        self.name.split('::').last.downcase
      end

      def self.package
        fail NotImplementedError
      end

      def routes
        @routes ||= {}
      end

      def route(name, options = {})
        route = routes.fetch(name) { fail NoentRouteError } 
        call(route, options)
      end
    end
  end
end
