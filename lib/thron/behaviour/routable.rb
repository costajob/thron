require 'httparty'
require_relative '../config'

module Thron
  Route = Struct::new(:method, :url, :content_type)

  module Routable
    include HTTParty

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

    def call(route, options)
      self.class.send(route.method, route.url, options)
    end
  end
end
