require_relative 'session'

module Thron
  module Gateway
    class Client < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def self.routes
        @routes ||= {
          client_detail: Route::factory(name: 'detailClient', package: PACKAGE, verb: Route::Verbs::GET),
          update_audit_duration_days: Route::factory(name: 'updateAuditDurationDays', package: PACKAGE),
          enable_secure_connection: Route::factory(name: 'updateSecureConnectionEnabled', package: PACKAGE),
          trash_properties_older_than: Route::factory(name: 'updateTrashProperties', package: PACKAGE)
        }
      end

      def client_detail
        query = { 
          clientId: self.client_id,
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          name = response.body.delete('name')
          name_hash = name ? { name: name } : {}
          response.body = Entity::Base::new(response.body.fetch('properties') { {} }.merge(name_hash))
        end
      end
      
      def update_audit_duration_days(days:)
        body = { 
          clientId: self.client_id,
          auditDurationDays: days.to_i
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def enable_secure_connection(enabled:)
        body = { 
          clientId: self.client_id,
          secureConnectionEnabled: !!enabled
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def trash_properties_older_than(days:)
        body = { 
          clientId: self.client_id,
          properties: {
            removeContentsOlderThan: days.to_i
          }
        }
        route(to: __callee__, body: body, token_id: token_id)
      end
    end
  end
end
