require 'forwardable'
Dir[Thron.root.join('lib', 'thron', 'gateway', '*.rb')].each { |f| require f }

module Thron
  class User
    extend Forwardable

    attr_accessor :access_gateway
    def_delegators :access_gateway, :logout, :validate_token, :validate_roles, :validate_capabilities

    def initialize(username:, password:)
      @username, @password = username, password
      @access_gateway = Gateway::AccessManager::new
    end 

    def login
      access_gateway.login(username: @username, password: @password)
      @token_id = access_gateway.token_id
    end

    private

    def gateways
      return [] unless @token_id
      @gateways ||= Gateway::constants.reduce({}) do |acc, name|
        continue unless (klass = Gateway.const_get(name)) < Gateway::Session
        acc[name] = klass::new(token_id: @token_id); acc
      end
    end
  end
end
