require 'forwardable'
Dir[Thron.root.join('lib', 'thron', 'gateway', '*.rb')].each { |f| require f }

module Thron
  class User
    extend Forwardable
    
    def_delegators :@access_gateway, *Gateway::AccessManager::routes.keys

    def self.session_gateways
      @session_gateways ||= Gateway::constants.select do |name|
        Gateway.const_get(name) < Gateway::Session
      end
    end

    self.session_gateways.each do |name|
      gateway = Gateway.const_get(name)
      def_delegators "@gateways[:#{name}]", *(gateway.routes::keys + gateway.paginator_methods)
    end
    
    attr_reader :token_id, :gateways

    def initialize
      @access_gateway = Gateway::AccessManager::new
    end 

    def login(args)
      @access_gateway.login(args).tap do |response|
        @token_id = @access_gateway.token_id
        refresh_gateways
      end
    end

    def logout
      return unless logged?
      @token_id = @access_gateway.token_id = nil
      @gateways = nil
    end

    def disguise(args)
      response = su(args)
      response.body[:id].tap do |token_id|
        return response.error unless token_id
        original_token, @token_id = @token_id, token_id
        refresh_gateways
        yield if block_given?
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
      @access_gateway.token_id = @token_id
      @gateways.each do |name, gateway|
        gateway.token_id = @token_id
        gateway.reset_paginators
      end
    end
  end
end
