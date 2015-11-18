require 'thron/gateway/session'
require 'thron/entity/image'

module Thron
  module Gateway
    class VUserManager < Session

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      paginate :find_users

      def self.routes
        @routes ||= {
          create_user: Route::factory(name: 'create', package: PACKAGE),
          user_detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET),
          find_users: Route::factory(name: 'findByProperties', package: PACKAGE),
          check_credentials: Route::factory(name: 'login', package: PACKAGE),
          temporary_token: Route::factory(name: 'resetPassword', package: PACKAGE),
          update_password: Route::factory(name: 'changePassword', package: PACKAGE),
          update_status: Route::factory(name: 'changeUserStatus', package: PACKAGE),
          update_capabilities_and_roles: Route::factory(name: 'updateCapabilitiesAndRoles', package: PACKAGE),
          update_external_id: Route::lazy_factory(name: 'updateExternalId', package: PACKAGE),
          update_image: Route::factory(name: 'updateImage', package: PACKAGE),
          update_settings: Route::factory(name: 'updateSettings', package: PACKAGE),
          update_user: Route::lazy_factory(name: 'updateUser', package: PACKAGE),
          upgrade_user: Route::factory(name: 'upgradeUser', package: PACKAGE)
        }
      end

      def create_user(username:, password:, data:)
        body = { 
          clientId: client_id,
          newUser: {
            username: username,
            password: password
          }
        }.merge(data)
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('user') { {} })
        end
      end

      def user_detail(username:, options: {}, offset: 0, limit: 0)
        query = {
          clientId: client_id,
          username: username,
          offset: offset.to_i,
          numberOfResults: limit.to_i
        }.merge(options)
        route(to: __callee__, query: query, token_id: token_id, dash: false) do |response|
          user = response.body.delete('user') { {} }
          response.body = Entity::Base::new(response.body.merge(user))
        end
      end

      def find_users(criteria: {}, order_by: nil, options: {}, offset: 0, limit: 0)
        body = { 
          clientId: client_id,
          criteria: criteria,
          orderBy: order_by,
          fieldsOption: options,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('users') { [] }.map do |user|
            detail = user.delete('userDetail') { {} }
            Entity::Base::new(user.merge(detail))
          end
        end
      end

      def check_credentials(username:, password:)
        query = { 
          clientId: client_id,
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
          clientId: client_id,
          username: username,
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body['tmpToken']
        end
      end

      def update_password(username:, password:)
        query = { 
          clientId: client_id,
          username: username,
          newpassword: password
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def update_status(username:, data:)
        body = { 
          clientId: client_id,
          username: username,
          properties: data
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_capabilities_and_roles(username:, capabilities:)
        body = { 
          clientId: client_id,
          username: username,
          userCapabilities: capabilities
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_external_id(username:, external_id:)
        body = {
          externalId: external_id
        }
        route(to: __callee__, body: body, token_id: token_id, params: [client_id, username])
      end

      def update_image(username:, image:)
        body = {
          clientId: client_id,
          username: username,
          buffer: image
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_settings(username:, settings:)
        body = {
          clientId: client_id,
          username: username,
          settings: settings
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_user(username:, data:)
        body = {
          update: data
        }
        route(to: __callee__, body: body, token_id: token_id, params: [client_id, username])
      end

      def upgrade_user(username:, password:, data:)
        body = { 
          clientId: client_id,
          username: username,
          newPassword: password
        }.merge(data)
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('user') { {} })
        end
      end
    end
  end
end
