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

      def routes
        @routes ||= {
          login: Route::new(:post, "/#{self.class.package}/login/#{@client_id}", :json)
        }
      end

      def login(username: Config.thron.username, password: Config.thron.password)
        options = {
          username: username,
          password: password
        }
        route(:login, options)
      end
    end
  end
end
