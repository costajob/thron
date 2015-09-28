require 'httparty'
require_relative '../config'
require_relative '../route'

module Thron
  module Routable
    include HTTParty

    class NoentRouteError < StandardError; end

    def self.included(klass)
      klass.extend ClassMethods
      klass.class_eval do
        include HTTParty
        base_uri base_url
      end
    end

    module ClassMethods
      def base_url
        "http://#{Config::thron.client_id}#{Config::thron.base_url}"
      end 
    end

    private

    def token_headers(token_id)
      return {} unless token_id
      { 'X-TOKENID' => token_id }
    end

    def routes
      {}
    end

    def route(to:, query: {}, token_id: nil)
      route = routes.fetch(to) { fail NoentRouteError } 
      self.class.send(route.verb, 
                      route.url, 
                      { query: query, headers: route.headers(token_id) })
    end
  end
end
