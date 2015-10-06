require_relative 'session'
require_relative '../entity/user'
require_relative '../entity/fields_option'
require_relative '../entity/user_criteria'

module Thron
  module Gateway
    class VUserManager < Session

      PACKAGE      = Package.new(:xsso, :resources, self.service_name)
      DEFAULT_TYPE = 'PLATFORM_USER'

      def create(user: Entity::User::default(type: DEFAULT_TYPE))
        body = user.to_payload.tap do |payload|
          payload['newUser'] = payload.delete('credential')
        end.merge({ clientId: self.client_id })
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          return Entity::User::factory(response.body.fetch('user') { {} }) if response.is_200?
        end
      end

      def change_password(username:, password:)
        query = { 
          clientId: self.client_id,
          username: username,
          newpassword: password
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false)
      end

      def change_status(username:, active: false, expire_at: nil)
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

      def detail(username:, fields_option: Entity::FieldsOption::default, offset: 0, limit: 0)
        query = {
          clientId: self.client_id,
          username: username,
          returnItags: fields_option.i_tags,
          returnImetadata: fields_option.i_metadata,
          offset: offset.to_i,
          numberOfResults: limit.to_i
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false) do |response|
          return Entity::User::factory(response.body.fetch('user') { {} }) if response.is_200?
        end
      end

      def find(criteria: Entity::UserCriteria::default, order_by: nil, fields_option: Entity::FieldsOption::default, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload,
          orderBy: order_by,
          fieldsOption: fields_option.to_payload,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          return response.body.fetch('users') { [] }.map do |user|
            Entity::User::factory(user.fetch('userDetail') { {} })
          end if response.is_200?
        end
      end

      def active?(username:, password:)
        query = { 
          clientId: self.client_id,
          username: username,
          password: password
        }
        route(to: __callee__, query: query, token_id: @token_id, dash: false) do |response|
          return Entity::User::factory(response.body.fetch('user') { {} }) if response.is_200?
        end
      end

      def routes
        @routes ||= {
          create: Route::factory(name: 'create', package: PACKAGE),
          change_password: Route::factory(name: 'changePassword', package: PACKAGE),
          change_status: Route::factory(name: 'changeUserStatus', package: PACKAGE),
          detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::VERBS::GET),
          find: Route::factory(name: 'findByProperties', package: PACKAGE),
          active?: Route::factory(name: 'login', package: PACKAGE)
        }
      end
    end
  end
end
