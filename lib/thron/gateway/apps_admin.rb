require_relative 'session'

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

      def add_group_app(app_id:, group_id:, capabilities:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          groupId: group_id,
          userCaps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_snippet(app_id:, data:, capabilities:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          snippet: data,
          caps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('snippet') { {} })
        end
      end

      def add_user_app(app_id:, username:, capabilities:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          username: username,
          userCaps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_app(data:, options:)
        body = { 
          clientId: self.client_id,
          app: data,
          options: options
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('app') { {} })
        end
      end

      def remove_app(app_id:)
        body = { 
          clientId: self.client_id,
          appId: app_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_group_app(app_id:, group_id:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          groupId: group_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_snippet(app_id:, snippet_id:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          snippetId: snippet_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_user_app(app_id:, username:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          username: username
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_app(app_id:, data:, capabilities:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          update: data,
          caps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('app') { {} })
        end
      end

      def update_snippet(app_id:, snippet_id:, data:, capabilities:)
        body = { 
          clientId: self.client_id,
          appId: app_id,
          snippetId: snippet_id,
          snippet: data,
          caps: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('snippet') { {} })
        end
      end
    end
  end
end
