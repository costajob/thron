require 'httparty'
require_relative '../config'
require_relative '../route'
require_relative '../response'
require_relative '../circuit_breaker'

module Thron
  module Routable
    include HTTParty

    DEBUG = false

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

    def routes
      {}
    end

    def route(to:, query: {}, body: {}, token_id: nil, dash: true, params: [])
      route = fetch_route(to, params)
      body = body.to_json if !body.empty? && route.json?
      self.class.circuit_breaker.monitor do
        raw = Thread.new do 
          self.class.send(route.verb, 
                          route.url, 
                          { query: query, 
                            body: body, 
                            headers: route.headers(token_id: token_id, dash: dash) })
        end
        info(query, body, route, token_id, dash, raw)
        Response::new(raw.value).tap do |response|
          yield(response) if block_given?
        end
      end
    rescue CircuitBreaker::OpenError
      warn "Circuit breaker is open for process #{$$}"
      Response::new(OpenStruct::new(code: 200))
    end

    def fetch_route(to, params)
      routes.fetch(to) { fail NoentRouteError }.call(params)
    end

    def info(query, body, route, token_id, dash, raw)
      puts "\n",
        "*" * 50,
        "#{route.verb.upcase} REQUEST:",
        "  * url: #{route.url}",
        "  * query: #{query.inspect}",
        "  * body: #{body.inspect}",
        "  * headers: #{route.headers(token_id: token_id, dash: dash)}",
        "  * raw: #{raw.value.inspect}",
        "*" * 50,
        "\n" if DEBUG
    end
  end
end
