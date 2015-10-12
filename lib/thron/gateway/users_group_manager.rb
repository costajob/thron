require_relative 'session'

module Thron
  module Gateway
    class UsersGroupManager < Session

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def create(data: Entity::Base::new(active: false))
        body = { 
          clientId: self.client_id,
          usersGroup: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('group') { {} })
        end
      end

      def remove(id:, force: false)
        body = { 
          clientId: self.client_id,
          groupId: id,
          force: force
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def detail(id:, fields_option: Entity::Base::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          groupId: id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: fields_option.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          group = response.body.delete('group') { {} }
          response.body = Entity::Base::new(response.body.merge(group))
        end
      end

      def find(criteria: Entity::Base::new(active: true), order_by: nil, fields_option: Entity::Base::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload,
          orderBy: order_by,
          fieldsOption: fields_option.to_payload,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('groups') { [] }.map do |group|
            detail = group.delete('groupDetail') { {} }
            Entity::Base::new(group.merge(detail))
          end
        end
      end

      %i[link_users unlink_users].each do |name|
        define_method(name) do |*args|
          group_id = args.last.fetch(:id)
          usernames = args.last.fetch(:usernames) { [] }
          body = { 
            clientId: self.client_id,
            userList: {
              usernames: usernames
            },
            groupId: group_id
          }
          route(to: name, body: body, token_id: token_id)
        end
      end

      def update(data:)
        body = {
          update: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id, params: [self.client_id, data.id])
      end

      def update_external_id(id:, external_id: Entity::Base::new)
        body = {
          externalId: external_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id, params: [self.client_id, id])
      end

      def self.routes
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
