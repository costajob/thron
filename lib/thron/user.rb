require 'forwardable'
Dir[Thron.root.join('lib', 'thron', 'gateway', '*.rb')].each { |f| require f }

module Thron
  class User
    extend Forwardable

    CANNOT_DISGUISE = :cannot_disguise
    
    def self.session_gateways
      @session_gateways ||= Gateway::constants.select do |name|
        Gateway.const_get(name) < Gateway::Session
      end
    end

    def_delegators :@access_gateway, *Gateway::AccessManager::routes.keys
    self.session_gateways.each do |name|
      def_delegators "@gateways[:#{name}]", *Gateway.const_get(name).routes::keys
    end
    
    attr_reader :token_id

    def initialize
      @access_gateway = Gateway::AccessManager::new
    end 

    def login(args)
      @access_gateway.login(args).tap do |response|
        @token_id = @access_gateway.token_id
        refresh_gateways
      end
    end

    def disguise(args)
      su(args).body[:id].tap do |token_id|
        return CANNOT_DISGUISE unless token_id
        original_token, @token_id = @token_id, token_id
        refresh_gateways
        yield
        @token_id = original_token 
        refresh_gateways
      end
    end

    def logged?
      !!@token_id
    end

    private 
    
    def initialize_gateways
      self.class.session_gateways.reduce({}) do |acc, name|
        acc[name] = Gateway.const_get(name)::new(token_id: @token_id); acc
      end
    end

    def refresh_gateways
      return unless logged?
      return (@gateways = initialize_gateways) unless @gateways
      @gateways.each do |name, gateway|
        gateway.token_id = @token_id
      end
    end
  end
end
