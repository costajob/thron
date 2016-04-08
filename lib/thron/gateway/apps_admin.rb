require 'thron/gateway/session'

module Thron
  module Gateway
    class AppsAdmin < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def self.routes
        @routes ||= {
          add_group_app: Route::factory(name: 'addGroupApp', package: PACKAGE),
          add_snippet: Route::factory(name: 'addSnippet', package: PACKAGE),
          add_user_app: Route::factory(name: 'addUserApp', package: PACKAGE),
          create_app: Route::factory(name: 'create', package: PACKAGE),
          remove_app: Route::factory(name: 'remove', package: PACKAGE),
          remove_group_app: Route::factory(name: 'removeGroupApp', package: PACKAGE),
          remove_snippet: Route::factory(name: 'removeSnippet', package: PACKAGE),
          remove_user_app: Route::factory(name: 'removeUserApp', package: PACKAGE),
          update_app: Route::factory(name: 'updateApp', package: PACKAGE),
          update_snippet: Route::factory(name: 'updateSnippet', package: PACKAGE)
        }
      end

      def add_group_app(options = {})
        app_id = options[:app_id]
        group_id = options[:group_id]
        capabilities = options[:capabilities]
        body = { 
          clientId: client_id,
          appId: app_id,
          groupId: group_id,
          userCaps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_snippet(options = {})
        app_id = options[:app_id]
        data = options[:data]
        capabilities = options[:capabilities]
        body = { 
          clientId: client_id,
          appId: app_id,
          snippet: data,
          caps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('snippet') { {} })
        end
      end

      def add_user_app(options = {})
        app_id = options[:app_id]
        username = options[:username]
        capabilities = options[:capabilities]
        body = { 
          clientId: client_id,
          appId: app_id,
          username: username,
          userCaps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_app(options = {})
        data = options[:data]
        options = options.fetch(:options) { {} }
        body = { 
          clientId: client_id,
          app: data,
          options: options
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('app') { {} })
        end
      end

      def remove_app(options = {})
        app_id = options[:app_id]
        body = { 
          clientId: client_id,
          appId: app_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_group_app(options = {})
        app_id = options[:app_id]
        group_id = options[:group_id]
        body = { 
          clientId: client_id,
          appId: app_id,
          groupId: group_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_snippet(options = {})
        app_id = options[:app_id]
        snippet_id = options[:snippet_id]
        body = { 
          clientId: client_id,
          appId: app_id,
          snippetId: snippet_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_user_app(options = {})
        app_id = options[:app_id]
        username = options[:username]
        body = { 
          clientId: client_id,
          appId: app_id,
          username: username
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_app(options = {})
        app_id = options[:app_id]
        data = options[:data]
        capabilities = options[:capabilities]
        body = { 
          clientId: client_id,
          appId: app_id,
          update: data,
          caps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('app') { {} })
        end
      end

      def update_snippet(options = {})
        app_id = options[:app_id]
        snippet_id = options[:snippet_id]
        data = options[:data]
        capabilities = options[:capabilities]
        body = { 
          clientId: client_id,
          appId: app_id,
          snippetId: snippet_id,
          snippet: data,
          caps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('snippet') { {} })
        end
      end
    end
  end
end
