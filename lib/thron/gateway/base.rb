require 'httparty'
require_relative '../config'
require_relative '../behaviour/parallelizable'

module Thron
  module Gateway
    class Base
      include Parallelizable
      include HTTParty

      def self.base_url
        @base_url ||= "http://#{Config::thron.client_id}#{Config::thron.base_url}"
      end 
      
      base_uri base_url

      def initialize(options: {})
        @options = options
      end
    end
  end
end
