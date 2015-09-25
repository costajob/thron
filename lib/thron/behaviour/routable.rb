require 'httparty'
require_relative '../config'
require_relative '../route'

module Thron
  module Routable
    include HTTParty

    DEBUG = true

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

    def call(route:, query: {}, headers: {})
      puts "REQUEST:",
        "\t * verb: #{route.verb.upcase}",
        "\t * url: #{self.class.base_url}#{route.url}",
        "\t * query: #{query}",
        "\t * headers: #{headers.merge(route.headers)}" if DEBUG
        self.class.send(route.verb, route.url, { query: query, headers: headers.merge(route.headers) })
    end
  end
end
