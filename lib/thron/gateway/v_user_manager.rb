require_relative 'session'
require_relative '../entity/user'
require_relative '../entity/fields_option'
require_relative '../entity/user_criteria'
require_relative '../entity/image'

module Thron
  module Gateway
    class VUserManager < Session

      PACKAGE      = Package.new(:xsso, :resources, self.service_name)
      DEFAULT_TYPE = 'PLATFORM_USER'

      def create(user: Entity::User::new)
        body = user.to_payload.tap do |payload|
          payload['newUser'] = payload.delete('credential')
        end.merge({ clientId: self.client_id })
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = Entity::User::factory(response.body.fetch('user') { {} })
        end
      end

      def detail(username:, fields_option: Entity::FieldsOption::new, offset: 0, limit: 0)
        query = {
          clientId: self.client_id,
          username: username,
          returnItags: fields_option.i_tags,
          returnImetadata: fields_option.i_metadata,
          offset: offset.to_i,
          numberOfResults: limit.to_i
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false) do |response|
          response.mapped = Entity::User::factory(response.body.fetch('user') { {} })
        end
      end

      def find(criteria: Entity::UserCriteria::new, order_by: nil, fields_option: Entity::FieldsOption::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload,
          orderBy: order_by,
          fieldsOption: fields_option.to_payload,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = response.body.fetch('users') { [] }.map do |user|
            Entity::User::factory(user.fetch('userDetail') { {} })
          end
        end
      end

      def active?(username:, password:)
        query = { 
          clientId: self.client_id,
          username: username,
          password: password
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false) do |response|
          response.mapped = Entity::User::factory(response.body.fetch('user') { {} })
        end
      end

      def temp_token(username:)
        body = { 
          clientId: self.client_id,
          username: username,
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = response.body['tmpToken']
        end
      end

      def update_password(username:, password:)
        query = { 
          clientId: self.client_id,
          username: username,
          newpassword: password
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false)
      end

      def update_status(username:, active: false, expire_at: nil)
        body = { 
          clientId: self.client_id,
          username: username,
          properties: {
            active: active,
            expiryDate: expire_at
          }
        }
        route(to: __callee__, body: body, token_id: @token_id)
      end

      def update_capabilities(username:, capabilities: Entity::Capabilities::new)
        body = { 
          clientId: self.client_id,
          username: username,
          userCapabilities: capabilities.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id)
      end

      def update_external_id(username:, external_id:)
        body = {
          externalId: external_id.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id, params: [self.client_id, username])
      end

      def update_image(username:, image:)
        body = {
          clientId: self.client_id,
          username: username,
          buffer: image.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id)
      end

      def update_settings(username:, quota: 0, lock_template: nil)
        body = {
          clientId: self.client_id,
          username: username,
          settings: {
            userQuota: quota,
            userLockTemplate: lock_template
          }
        }
        route(to: __callee__, body: body, token_id: @token_id)
      end

      def update(username:, data: Entity::User::new)
        body = {
          update: data.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id, params: [self.client_id, username])
      end

      def upgrade(username:, password:, data: Entity::User::new)
        body = data.to_payload.tap do |payload|
          payload['newUserDetail'] = payload.delete('detail')
          preferences = payload.delete('userPreferences') { {} }
          payload['newUserParams'] = { 'userPreferences' => preferences } 
        end.merge({ 
          clientId: self.client_id,
          username: username,
          newPassword: password
        })
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = Entity::User::factory(response.body.fetch('user') { {} })
        end
      end

      def routes
        @routes ||= {
          create: Route::factory(name: 'create', package: PACKAGE),
          detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET),
          find: Route::factory(name: 'findByProperties', package: PACKAGE),
          active?: Route::factory(name: 'login', package: PACKAGE),
          temp_token: Route::factory(name: 'resetPassword', package: PACKAGE),
          update_password: Route::factory(name: 'changePassword', package: PACKAGE),
          update_status: Route::factory(name: 'changeUserStatus', package: PACKAGE),
          update_capabilities: Route::factory(name: 'updateCapabilitiesAndRoles', package: PACKAGE),
          update_external_id: Route::lazy_factory(name: 'updateExternalId', package: PACKAGE),
          update_image: Route::factory(name: 'updateImage', package: PACKAGE),
          update_settings: Route::factory(name: 'updateSettings', package: PACKAGE),
          update: Route::lazy_factory(name: 'updateUser', package: PACKAGE),
          upgrade: Route::factory(name: 'upgradeUser', package: PACKAGE)
        }
      end
    end
  end
end
