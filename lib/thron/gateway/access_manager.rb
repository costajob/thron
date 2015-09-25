require_relative 'base'

module Thron
  module Gateway
    class AccessManager < Base
      def self.package
        Package.new(:xsso, :resources, self.service_name)
      end

      class NoActiveSessionError < StandardError; end

      def initialize(client_id: Config.thron.client_id)
        @client_id = client_id
      end

      def login(username: Config.thron.username, password: Config.thron.password)
        query = {
          clientId: @client_id,
          username: username,
          password: password
        }
        route(to: :login, query: query).tap do |http_res|
          @token_id = http_res.parsed_response.fetch('tokenId')
        end
      end

      def logout
        check_session
        query = {
          clientId: @client_id
        }
        route(to: :logout, query: query, token_id: @token_id).tap do |http_res|
          @token_id = nil
        end
      end

      def validate_token
        check_session
        query = {
          clientId: @client_id
        }
        route(to: :validate_token, query: query, token_id: @token_id)
      end

      def validate_role(role:)
        check_session
        query = {
          clientId: @client_id,
          role: role
        }
        route(to: :validate_role, query: query, token_id: @token_id)
      end

      private

      def check_session
        fail NoActiveSessionError unless @token_id
      end

      def routes
        @routes ||= {
          login: Route::new(verb: 'post', url: "/#{self.class.package}/login/#{@client_id}", type: Route::TYPES::JSON),
          logout: Route::new(verb: 'post', url: "/#{self.class.package}/logout/#{@client_id}", type: Route::TYPES::PLAIN),
          validate_token: Route::new(verb: 'post', url: "/#{self.class.package}/validateToken/#{@client_id}", type: Route::TYPES::PLAIN),
          validate_role: Route::new(verb: 'post', url: "/#{self.class.package}/validateRole/#{@client_id}", type: Route::TYPES::PLAIN)
        }
      end
    end
  end
end
