require 'httparty'
require 'thron/config'
require 'thron/route'
require 'thron/circuit_breaker'
require 'thron/response'
require 'thron/logger'

module Thron
  module Routable
    include HTTParty

    class NoentRouteError < StandardError; end

    def self.included(klass)
      klass.extend ClassMethods
      klass.class_eval do
        include HTTParty
      end
    end

    def self.info(host, query, body, route, token_id, dash)
      info = [
        "\n",
        "*" * 50,
        'HTTP REQUEST:',
        "  * host: #{host}",
        "  * url: #{route.url}",
        "  * verb: #{route.verb.upcase}",
        "  * query: #{query.inspect}",
        "  * body: #{body.inspect}",
        "  * headers: #{route.headers(token_id: token_id, dash: dash)}",
        "*" * 50,
        "\n"
      ]
      puts info
      Thron::logger.debug info.join("\n")
    end

    module ClassMethods
      def circuit_breaker
        @circuit_breaker ||= CircuitBreaker::new
      end

      def routes
        fail NotImplementedError
      end
    end

    def route(to:, query: {}, body: {}, token_id: nil, dash: true, params: [])
      route = fetch_route(to, params)
      body = body.to_json if !body.empty? && route.json?
      self.class.circuit_breaker.monitor do
        raw = self.class.send(route.verb, 
                              route.url, 
                              { query: query, 
                                body: body, 
                                headers: route.headers(token_id: token_id, dash: dash) })
        Routable::info(self.class.default_options[:base_uri], query, body, route, token_id, dash)
        Response::new(raw).tap do |response|
          yield(response) if response.is_200? && block_given?
        end
      end
    rescue CircuitBreaker::OpenError
      Thron::logger.error "Circuit breaker is open for process #{$$}"
      Response::new(OpenStruct::new(code: 200))
    end

    private def fetch_route(to, params)
      self.class.routes.fetch(to) { fail NoentRouteError, "#{to} route does not exist!" }.call(params)
    end
  end
end
