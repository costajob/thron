require 'forwardable'
Dir[Thron.root.join('lib', 'thron', 'gateway', '*.rb')].each { |f| require f }

module Thron
  class User
    extend Forwardable

    def self.session_gateways
      @session_gateways ||= Gateway::constants.select do |name|
        Gateway.const_get(name) < Gateway::Session
      end
    end

    def_delegators :@access_gateway, *Gateway::AccessManager::routes.keys
    self.session_gateways.each do |name|
      def_delegators "@gateways[:#{name}]", *Gateway.const_get(name).routes::keys
    end

    def initialize
      @access_gateway = Gateway::AccessManager::new
    end 

    def login(args)
      @access_gateway.login(args).tap do |response|
        @gateways = initialize_gateways
      end
    end

    def logged?
      !!@access_gateway.token_id
    end

    private def initialize_gateways
      return {} unless logged?
      self.class.session_gateways.reduce({}) do |acc, name|
        acc[name] = Gateway.const_get(name)::new(token_id: @access_gateway.token_id); acc
      end
    end
  end
end
