require_relative 'session'

module Thron
  module Gateway
    class UsersGroupManager < Session

      paginate :find_groups

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      def self.routes
        @routes ||= {
          create_group: Route::factory(name: 'createGroup', package: PACKAGE),
          remove_group: Route::factory(name: 'removeGroup', package: PACKAGE),
          group_detail: Route::factory(name: 'detailGroup', package: PACKAGE),
          find_groups: Route::factory(name: 'findGroupsByProperties', package: PACKAGE),
          link_users_to_group: Route::factory(name: 'linkUserToGroup', package: PACKAGE),
          unlink_users_from_group: Route::factory(name: 'unlinkUserToGroup', package: PACKAGE),
          update_group: Route::lazy_factory(name: 'update', package: PACKAGE),
          update_group_external_id: Route::lazy_factory(name: 'updateExternalId', package: PACKAGE)
        }
      end

      def create_group(data: Entity::Base::new(active: false))
        body = { 
          clientId: self.client_id,
          usersGroup: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('group') { {} })
        end
      end

      def remove_group(id:, force: false)
        body = { 
          clientId: self.client_id,
          groupId: id,
          force: force
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def group_detail(id:, options: Entity::Base::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          groupId: id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: options.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          group = response.body.delete('group') { {} }
          response.body = Entity::Base::new(response.body.merge(group))
        end
      end

      def find_groups(criteria: Entity::Base::new(active: true), order_by: nil, options: Entity::Base::new, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_payload,
          orderBy: order_by,
          fieldsOption: options.to_payload,
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

      %i[link_users_to_group unlink_users_from_group].each do |name|
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

      def update_group(data:)
        body = {
          update: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id, params: [self.client_id, data.id])
      end

      def update_group_external_id(id:, external_id: Entity::Base::new)
        body = {
          externalId: external_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id, params: [self.client_id, id])
      end
    end
  end
end
