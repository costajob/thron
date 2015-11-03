require 'forwardable'
Dir[Thron.root.join('lib', 'thron', 'gateway', '*.rb')].each { |f| require f }

module Thron
  class User
    extend Forwardable

    def_delegators :@access_gateway, :logout, :validate_token, :validate_roles, :validate_capabilities

    def initialize
      @access_gateway = Gateway::AccessManager::new
    end 

    def login(args)
      @access_gateway.login(args)
      @gateways = gateways
    end

    private

    def gateways
      Gateway::constants.select do |name|
        Gateway.const_get(name) < Gateway::Session
      end.reduce({}) do |acc, name|
        acc[name] = Gateway.const_get(name)::new(token_id: @access_gateway.token_id); acc
      end
    end
  end
end
