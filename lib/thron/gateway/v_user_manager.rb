require_relative 'session'
require_relative '../entity/image'

module Thron
  module Gateway
    class VUserManager < Session

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def self.routes
        @routes ||= {
          create_user: Route::factory(name: 'create', package: PACKAGE),
          user_detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET),
          find_users: Route::factory(name: 'findByProperties', package: PACKAGE),
          check_user: Route::factory(name: 'login', package: PACKAGE),
          temporary_token: Route::factory(name: 'resetPassword', package: PACKAGE),
          update_password: Route::factory(name: 'changePassword', package: PACKAGE),
          update_status: Route::factory(name: 'changeUserStatus', package: PACKAGE),
          update_capabilities: Route::factory(name: 'updateCapabilitiesAndRoles', package: PACKAGE),
          update_external_id: Route::lazy_factory(name: 'updateExternalId', package: PACKAGE),
          update_image: Route::factory(name: 'updateImage', package: PACKAGE),
          update_settings: Route::factory(name: 'updateSettings', package: PACKAGE),
          update_user: Route::lazy_factory(name: 'updateUser', package: PACKAGE),
          upgrade_user: Route::factory(name: 'upgradeUser', package: PACKAGE)
        }
      end

      def create_user(username:, password:, data: Entity::Base::new(user_type: 'PLATFORM_USER'))
        body = { 
          clientId: self.client_id,
          newUser: {
            username: username,
            password: password
          }
        }.merge(data.to_payload)
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('user') { {} })
        end
      end

      def user_detail(username:, options: Entity::Base::new, offset: 0, limit: 0)
        query = {
          clientId: self.client_id,
          username: username,
          offset: offset.to_i,
          numberOfResults: limit.to_i
        }.merge(options.to_payload)
        route(to: __callee__, query: query, token_id: token_id, dash: false) do |response|
          user = response.body.delete('user') { {} }
          response.body = Entity::Base::new(response.body.merge(user))
        end
      end

      def find_users(args = {})
        preload = args.delete(:preload) { 0 }
        body = ->(limit, offset) { _find(args.merge!({ offset: offset, limit: limit })) }
        Paginator::new(body: body, preload: preload)
      end

      def check_user(username:, password:)
        query = { 
          clientId: self.client_id,
          username: username,
          password: password
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false) do |response|
          user = response.body.delete('user') { {} }
          response.body = Entity::Base::new(response.body.merge(user))
        end
      end

      def temporary_token(username:)
        body = { 
          clientId: self.client_id,
          username: username,
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body['tmpToken']
        end
      end

      def update_password(username:, password:)
        query = { 
          clientId: self.client_id,
          username: username,
          newpassword: password
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def update_status(username:, data: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          username: username,
          properties: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_capabilities(username:, capabilities: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          username: username,
          userCapabilities: capabilities.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_external_id(username:, external_id: Entity::Base::new)
        body = {
          externalId: external_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id, params: [self.client_id, username])
      end

      def update_image(username:, image:)
        body = {
          clientId: self.client_id,
          username: username,
          buffer: image.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_settings(username:, settings: Entity::Base::new)
        body = {
          clientId: self.client_id,
          username: username,
          settings: settings.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_user(username:, data: Entity::Base::new)
        body = {
          update: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id, params: [self.client_id, username])
      end

      def upgrade_user(username:, password:, data: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          username: username,
          newPassword: password
        }.merge(data.to_payload)
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('user') { {} })
        end
      end

      private def _find(criteria: Entity::Base::new(active: true), order_by: nil, options: Entity::Base::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload,
          orderBy: order_by,
          fieldsOption: options.to_payload,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: :find_users, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('users') { [] }.map do |user|
            detail = user.delete('userDetail') { {} }
            Entity::Base::new(user.merge(detail))
          end
        end
      end
    end
  end
end
