require 'httparty'
require_relative '../config'
require_relative '../behaviour/parallelizable'

module Thron
  module Gateway
    class Base
      include Parallelizable
      include HTTParty
      
      Package = Struct::new(:name, :domain, :service) do
        def to_s
          "#{name}/#{domain}/#{service}"
        end
      end

      def self.base_url
        @base_url ||= "http://#{Config::thron.client_id}#{Config::thron.base_url}"
      end 

      def self.service_name
        self.name.split('::').last.downcase
      end

      def self.package
        fail NotImplementedError
      end
      
      base_uri base_url

      def initialize(options: {})
        @options = options
      end
    end
  end
end
