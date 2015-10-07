require_relative 'session'
require_relative '../entity/group'
require_relative '../entity/fields_option'
require_relative '../entity/group_criteria'

module Thron
  module Gateway
    class UsersGroupManager < Session

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      attr_reader :criteria, :fields_option, :group_data

      def initialize(*args)
        @criteria      = Entity::GroupCriteria::new
        @fields_option = Entity::FieldsOption::new
        @group_data    = Entity::Group::new
        super
      end

      def create(group: @group_data)
        body = { 
          clientId: self.client_id,
          usersGroup: group.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = Entity::Group::factory(response.body.fetch('group') { {} })
        end
      end

      def remove(id:, force: false)
        body = { 
          clientId: self.client_id,
          groupId: id,
          force: force
        }
        route(to: __callee__, body: body, token_id: @token_id)
      end

      def detail(id:, fields_option: @fields_option, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          groupId: id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: fields_option.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = Entity::Group::factory(response.body.fetch('group') { {} })
        end
      end

      def find(criteria: @criteria, order_by: nil, fields_option: @fields_option, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload,
          orderBy: order_by,
          fieldsOption: fields_option.to_payload,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = response.body.fetch('groups') { [] }.map do |group|
            Entity::Group::factory(group.fetch('groupDetail') { {} })
          end
        end
      end

      %i[link_users unlink_users].each do |name|
        define_method(name) do |*args|
          group_id = args.last.fetch(:id)
          users    = args.last.fetch(:users) { [] }
          body = { 
            clientId: self.client_id,
            userList: {
              usernames: users
            },
            groupId: group_id
          }
          route(to: name, body: body, token_id: @token_id)
        end
      end

      def update(group:)
        body = {
          update: group.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id, params: [self.client_id, group.id])
      end

      def update_external_id(id:, external_id:)
        body = {
          externalId: external_id.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id, params: [self.client_id, id])
      end

      def routes
        @routes ||= {
          create: Route::factory(name: 'createGroup', package: PACKAGE),
          remove: Route::factory(name: 'removeGroup', package: PACKAGE),
          detail: Route::factory(name: 'detailGroup', package: PACKAGE),
          find: Route::factory(name: 'findGroupsByProperties', package: PACKAGE),
          link_users: Route::factory(name: 'linkUserToGroup', package: PACKAGE),
          unlink_users: Route::factory(name: 'unlinkUserToGroup', package: PACKAGE),
          update: Route::lazy_factory(name: 'update', package: PACKAGE),
          update_external_id: Route::lazy_factory(name: 'updateExternalId', package: PACKAGE)
        }
      end
    end
  end
end
