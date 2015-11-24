require 'thron/gateway/session'

module Thron
  module Gateway
    class UsersGroupManager < Session

      PACKAGE = Package.new(:xsso, :resources, self.service_name)

      paginate :find_groups

      def self.routes
        @routes ||= {
          create_group: Route::factory(name: 'createGroup', package: PACKAGE),
          remove_group: Route::factory(name: 'removeGroup', package: PACKAGE),
          group_detail: Route::factory(name: 'detailGroup', package: PACKAGE),
          find_groups: Route::factory(name: 'findGroupsByProperties', package: PACKAGE),
          link_users_to_group: Route::factory(name: 'linkUserToGroup', package: PACKAGE),
          unlink_users_to_group: Route::factory(name: 'unlinkUserToGroup', package: PACKAGE),
          update_group: Route::lazy_factory(name: 'update', package: PACKAGE),
          update_group_external_id: Route::lazy_factory(name: 'updateExternalId', package: PACKAGE)
        }
      end

      def create_group(data:)
        body = { 
          clientId: client_id,
          usersGroup: data
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('group') { {} })
        end
      end

      def remove_group(group_id:, force: false)
        body = { 
          clientId: client_id,
          groupId: group_id,
          force: force
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def group_detail(group_id:, options: {}, offset: 0, limit: 0)
        body = { 
          clientId: client_id,
          groupId: group_id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: options
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          group = response.body.delete('group') { {} }
          response.body = Entity::Base::factory(response.body.merge!(group))
        end
      end

      def find_groups(criteria: {}, order_by: nil, options: {}, offset: 0, limit: 0)
        body = { 
          clientId: client_id,
          criteria: criteria,
          orderBy: order_by,
          fieldsOption: options,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('groups') { [] })
        end
      end

      %i[link_users_to_group unlink_users_to_group].each do |name|
        define_method(name) do |*args|
          group_id = args.last.fetch(:group_id)
          usernames = args.last.fetch(:usernames) { [] }
          body = { 
            clientId: client_id,
            userList: {
              usernames: usernames
            },
            groupId: group_id
          }
          route(to: name, body: body, token_id: token_id)
        end
      end

      def update_group(group_id:, data:)
        body = {
          update: data
        }
        route(to: __callee__, body: body, token_id: token_id, params: [client_id, group_id])
      end

      def update_group_external_id(group_id:, external_id:)
        body = {
          externalId: external_id
        }
        route(to: __callee__, body: body, token_id: token_id, params: [client_id, group_id])
      end
    end
  end
end
