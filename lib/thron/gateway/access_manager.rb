require 'thron/gateway/base'

module Thron
  module Gateway
    class AccessManager < Base

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def self.routes
        @routes ||= {
          login: Route::factory(name: 'login', package: PACKAGE, params: [client_id]),
          logout: Route::factory(name: 'logout', package: PACKAGE, params: [client_id], type: Route::Types::PLAIN, accept: Route::Types::PLAIN),
          validate_capabilities: Route::factory(name: 'validateCapability', package: PACKAGE, params: [client_id], type: Route::Types::PLAIN, accept: Route::Types::PLAIN),
          validate_roles: Route::factory(name: 'validateRole', package: PACKAGE, params: [client_id], type: Route::Types::PLAIN, accept: Route::Types::PLAIN),
          validate_token: Route::factory(name: 'validateToken', package: PACKAGE, params: [client_id])
        }
      end

      def login(options = {})
        query = {
          username: options[:username],
          password: options[:password]
        }
        route(to: __callee__, query: query, dash: false) do |response|
          response.body = Entity::Base::factory(response.body)
          @token_id = response.body.token_id
        end
      end

      def logout
        check_session
        route(to: __callee__, token_id: token_id, dash: false) do |response|
          @token_id = nil
        end
      end

      def validate_capabilities(options = {})
        capabilities = options.fetch(:capabilities) { [] }
        check_session
        query = {
          capabilities: capabilities.join(',')
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false)
      end

      def validate_roles(options = {})
        roles = options.fetch(:roles) { [] }
        xor = options.fetch(:xor) { false }
        check_session
        separator = xor ? '|' : ','
        query = {
          role: roles.join(separator)
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false)
      end

      def validate_token(options = {})
        username = options[:username]
        check_session
        query = {
          username: username
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end
    end
  end
end
