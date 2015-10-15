require_relative 'base'

module Thron
  module Gateway
    class AccessManager < Base

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def login(username:, password:)
        query = {
          username: username,
          password: password
        }
        route(to: __callee__, query: query, dash: false) do |response|
          @token_id = response.body['tokenId']
          response.body = Entity::Base::new(response.body)
        end
      end

      def logout
        check_session
        route(to: __callee__, token_id: token_id, dash: false) do |response|
          @token_id = nil
        end
      end

      def validate_capabilities(capabilities: [])
        check_session
        query = {
          capabilities: capabilities.join(',')
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def validate_roles(roles: [], xor: false)
        check_session
        separator = xor ? '|' : ','
        query = {
          role: roles.join(separator)
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def validate_token
        check_session
        route(to: __callee__, token_id: token_id, dash: false)
      end

      def self.routes
        @routes ||= {
          login: Route::factory(name: 'login', package: PACKAGE, params: [client_id]),
          logout: Route::factory(name: 'logout', package: PACKAGE, params: [client_id], json: false),
          validate_capabilities: Route::factory(name: 'validateCapability', package: PACKAGE, params: [client_id], json: false),
          validate_roles: Route::factory(name: 'validateRole', package: PACKAGE, params: [client_id], json: false),
          validate_token: Route::factory(name: 'validateToken', package: PACKAGE, params: [client_id], json: false)
        }
      end
    end
  end
end
