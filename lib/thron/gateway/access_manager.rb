require_relative 'base'

module Thron
  module Gateway
    class AccessManager < Base

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def login(username: Config.thron.username, password: Config.thron.password)
        query = {
          username: username,
          password: password
        }
        route(to: __callee__, query: query).tap do |response|
          self.token_id = response.body.fetch('tokenId') { :no_token }
        end
      end

      def logout
        check_session
        route(to: __callee__, token_id: self.token_id).tap do |response|
          self.token_id = nil
        end
      end

      def validate_capabilities(capabilities = [])
        check_session
        query = {
          capabilities: capabilities.join(',')
        }
        route(to: __callee__, query: query, token_id: self.token_id)
      end

      def validate_roles(roles = [])
        check_session
        query = {
          role: roles.join(',')
        }
        route(to: __callee__, query: query, token_id: self.token_id)
      end

      def validate_token
        check_session
        route(to: __callee__, token_id: self.token_id)
      end

      def routes
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
