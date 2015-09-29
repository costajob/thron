require_relative 'base'
require_relative '../entity/group'
require_relative '../entity/fields_option'
require_relative '../entity/group_criteria'

module Thron
  module Gateway
    class UsersGroupManager < Base
      def self.package
        Package.new(:xsso, :resources, self.service_name)
      end

      def create_group(group: Entity::Group::default)
        check_session
        body = { 
          clientId: self.client_id,
          usersGroup: group.to_h
        }
        route(to: :create_group, body: body, token_id: self.token_id, dash: true)
      end

      def remove_group(group_id:, force: false)
        check_session
        body = { 
          clientId: self.client_id,
          groupId: group_id,
          force: force
        }
        route(to: __callee__, body: body, token_id: self.token_id, dash: true)
      end

      def detail_group(group_id:, fields_option: Entity::FieldsOption::default, offset: 0, limit: 0)
        check_session
        body = { 
          clientId: self.client_id,
          groupId: group_id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: fields_option.to_h
        }
        route(to: __callee__, body: body, token_id: self.token_id, dash: true)
      end

      def find_groups(criteria: Entity::GroupCriteria::default, order_by: nil, fields_option: Entity::FieldsOption::default, offset: 0, limit: 0)
        check_session
        body = { 
          clientId: self.client_id,
          criteria: criteria.to_h,
          orderBy: order_by,
          fieldsOption: fields_option.to_h,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: self.token_id, dash: true)
      end

      %i[link_users unlink_users].each do |name|
        define_method(name) do |*args|
          group_id = args.last.fetch(:group_id)
          users    = args.last.fetch(:users) { [] }
          check_session
          body = { 
            clientId: self.client_id,
            userList: {
              usernames: users
            },
            groupId: group_id
          }
          route(to: name, body: body, token_id: self.token_id, dash: true)
        end
      end

      def update(group:)
        routes[:update] = Route::factory(name: 'update', package: self.class.package, extra: [self.client_id, group.id])
        check_session
        body = {
          update: group.to_h 
        }
        route(to: name, body: body, token_id: self.token_id, dash: true)
      end

      def routes
        @routes ||= {
          create_group: Route::factory(name: 'createGroup', package: self.class.package),
          remove_group: Route::factory(name: 'removeGroup', package: self.class.package),
          detail_group: Route::factory(name: 'detailGroup', package: self.class.package),
          find_groups: Route::factory(name: 'findGroupsByProperties', package: self.class.package),
          link_users: Route::factory(name: 'linkUserToGroup', package: self.class.package),
          unlink_users: Route::factory(name: 'unlinkUserToGroup', package: self.class.package)
        }
      end
    end
  end
end
