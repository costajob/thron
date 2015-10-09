require_relative 'session'

module Thron
  module Gateway
    class UsersGroupManager < Session

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def create(group: Entity::Group::new)
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

      def detail(id:, fields_option: Entity::FieldsOption::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          groupId: id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: fields_option.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          detail = response.body.delete('group') { {} }
          response.mapped = Entity::Group::factory(response.body.merge!(detail))
        end
      end

      def find(criteria: Entity::GroupCriteria::new(active: true), order_by: nil, fields_option: Entity::FieldsOption::new, offset: 0, limit: 0)
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
            detail = group.delete('groupDetail') { {} }
            Entity::Group::factory(group.merge!(detail))
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
