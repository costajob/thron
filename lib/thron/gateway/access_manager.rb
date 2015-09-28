require_relative 'base'

module Thron
  module Gateway
    class AccessManager < Base
      def self.package
        Package.new(:xsso, :resources, self.service_name)
      end

      attr_reader :client_id

      def initialize(client_id: Config.thron.client_id)
        @client_id = client_id
      end

      def login(username: Config.thron.username, password: Config.thron.password)
        query = {
          clientId: client_id,
          username: username,
          password: password
        }
        route(to: :login, query: query).tap do |http_res|
          self.token_id = http_res.parsed_response.fetch('tokenId') { :no_token }
        end
      end

      def logout
        check_session
        query = { clientId: client_id }
        route(to: :logout, query: query, token_id: token_id).tap do |http_res|
          self.token_id = nil
        end
      end

      def validate_capabilities(capabilities = [])
        check_session
        query = {
          clientId: client_id,
          capabilities: capabilities
        }
        route(to: :validate_capabilities, query: query, token_id: token_id)
      end

      def validate_roles(roles = [])
        check_session
        query = {
          clientId: client_id,
          role: roles
        }
        route(to: :validate_roles, query: query, token_id: token_id)
      end

      def validate_token
        check_session
        query = { clientId: client_id }
        route(to: :validate_token, query: query, token_id: token_id)
      end

      def routes
        @routes ||= {
          login: Route::new(verb: 'post', url: route_url(:login), type: Route::TYPES::JSON),
          logout: Route::new(verb: 'post', url: route_url(:logout), type: Route::TYPES::PLAIN),
          validate_capabilities: Route::new(verb: 'post', url: route_url(:validateCapability), type: Route::TYPES::PLAIN),
          validate_roles: Route::new(verb: 'post', url: route_url(:validateRole), type: Route::TYPES::PLAIN),
          validate_token: Route::new(verb: 'post', url: route_url(:validateToken), type: Route::TYPES::PLAIN)
        }
      end

      private

      def route_url(name)
        "/#{self.class.package}/#{name}/#{client_id}"
      end
    end
  end
end
