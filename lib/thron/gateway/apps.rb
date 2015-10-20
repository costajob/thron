require_relative 'session'

module Thron
  module Gateway
    class Apps < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def detail(id:)
        body = { 
          clientId: self.client_id,
          appId: id
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('app') { {} })
        end
      end

      def list(criteria: Entity::Base::new(app_active: true))
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('apps') { [] }.map do |app|
            Entity::Base::new(app)
          end
        end
      end

      def find(criteria: Entity::Base::new(app_active: true))
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('apps') { [] }.map do |app|
            Entity::Base::new(app)
          end
        end
      end

      def login(id:)
        query = {
          clientId: self.client_id,
          appId: id
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false) do |response|
          response.body = Entity::Base::new(response.body.fetch('app') { {} })
        end
      end

      def self.routes
        @routes ||= {
          detail: Route::factory(name: 'appDetail', package: PACKAGE),
          list: Route::factory(name: 'appsList', package: PACKAGE),
          find: Route::factory(name: 'findByProperties', package: PACKAGE),
          login: Route::factory(name: 'loginApp', package: PACKAGE, verb: Route::Verbs::GET),
          login_snippet: Route::factory(name: 'loginSnippet', package: PACKAGE, verb: Route::Verbs::GET),
          su: Route::factory(name: 'su', package: PACKAGE)
        }
      end
    end
  end
end
