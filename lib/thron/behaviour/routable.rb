require 'httparty'
require_relative '../config'
require_relative '../route'
require_relative '../circuit_breaker'

module Thron
  module Routable
    include HTTParty

    DEBUG = true

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

      def circuit_breaker
        @circuit_breaker ||= CircuitBreaker::new
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

    def route(to:, query: {}, body: {}, token_id: nil)
      route = routes.fetch(to) { fail NoentRouteError } 
      body = body.to_json if !body.empty? && route.json?
      info(query, body, route, token_id)
      self.class.circuit_breaker.monitor do
        self.class.send(route.verb, 
                        route.url, 
                        { query: query, body: body, headers: route.headers(token_id) })
      end
    rescue CircuitBreaker::OpenError
      warn "Circuit breaker is open for process #{$$}"
      OpenStruct::new(parsed_response: {})
    end

    def info(query, body, route, token_id)
      return unless DEBUG
      puts "*" * 50,
        "#{route.verb.upcase} REQUEST:",
        "  * url: #{route.url}",
        "  * query: #{query.inspect}",
        "  * body: #{body.inspect}",
        "  * headers: #{route.headers(token_id)}",
        "*" * 50,
        "\n"
    end
  end
end
