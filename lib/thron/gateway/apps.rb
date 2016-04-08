require 'thron/gateway/session'

module Thron
  module Gateway
    class Apps < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def self.routes
        @routes ||= {
          app_detail: Route::factory(name: 'appDetail', package: PACKAGE),
          list_apps: Route::factory(name: 'appsList', package: PACKAGE),
          find_apps: Route::factory(name: 'findByProperties', package: PACKAGE),
          login_app: Route::factory(name: 'loginApp', package: PACKAGE, verb: Route::Verbs::GET),
          login_snippet: Route::factory(name: 'loginSnippet', package: PACKAGE, verb: Route::Verbs::GET),
          su: Route::factory(name: 'su', package: PACKAGE, accept: Route::Types::PLAIN)
        }
      end

      def app_detail(options = {})
        app_id = options[:app_id]
        body = { 
          clientId: client_id,
          appId: app_id
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('app') { {} })
        end
      end

      def list_apps(options = {})
        criteria = options.fetch(:criteria) { {} }
        body = { 
          clientId: client_id,
          criteria: criteria
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('apps') { [] })
        end
      end

      def find_apps(options = {})
        criteria = options.fetch(:criteria) { {} }
        body = { 
          clientId: client_id,
          criteria: criteria
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('apps') { [] })
        end
      end

      def login_app(options = {})
        app_id = options[:app_id]
        query = {
          clientId: client_id,
          appId: app_id
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false) do |response|
          response.body = Entity::Base::factory(response.body.fetch('app') { {} })
        end
      end

      def login_snippet(options = {})
        app_id = options[:app_id]
        snippet_id = options[:snippet_id]
        query = {
          clientId: client_id,
          appId: app_id,
          snippetId: snippet_id,
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false) do |response|
          response.body = Entity::Base::factory(response.body.fetch('snippet') { {} })
        end
      end

      def su(options = {})
        app_id = options[:app_id]
        username = options[:username]
        body = { 
          clientId: client_id,
          appId: app_id,
          username: username
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end
    end
  end
end
