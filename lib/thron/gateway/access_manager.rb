require_relative 'base'

module Thron
  module Gateway
    class AccessManager < Base
      def self.package
        Package.new(:xsso, :resources, self.service_name)
      end

      def initialize(client_id: Config.thron.client_id)
        @client_id = client_id
      end

      def login(username: Config.thron.username, password: Config.thron.password)
        query = {
          clientId: @client_id,
          username: username,
          password: password
        }
        route(to: :login, query: query)
      end

      def logout(token_id:)
        query = {
          clientId: @client_id
        }
        headers = {
          'X-TOKENID' => token_id
        }
        route(to: :logout, query: query, headers: headers)
      end

      private

      def routes
        @routes ||= {
          login: Route::new(verb: 'post', url: "/#{self.class.package}/login/#{@client_id}", type: Route::TYPES::JSON),
          logout: Route::new(verb: 'post', url: "/#{self.class.package}/logout/#{@client_id}", type: Route::TYPES::PLAIN)
        }
      end
    end
  end
end
