require_relative 'base'

module Thron
  module Gateway
    FieldsOption = Struct::new(:own_acl, :tags, :metadata) do
      def self.default
        new(false, false, false)
      end

      def to_h
        {
          returnOwnAcl: own_acl,
          returnItags: tags,
          returnImetadata: metadata
        }
      end
    end

    Criteria = Struct::new(:ids, :keyword, :active, :linked_username, :roles) do
      def self.default
        new([], nil, true, nil, [])
      end

      def to_h
        {
          ids: ids,
          textSearch: keyword,
          active: active,
          linkedUsername: linked_username,
          groupRoles: roles 
        }
      end
    end

    class UsersGroupManager < Base
      def self.package
        Package.new(:xsso, :resources, self.service_name)
      end

      def detail_group(group_id:, fields_option: FieldsOption::default, offset:, limit:)
        check_session
        query = { 
          clientId: client_id,
          groupId: group_id,
          offset: offset.to_i,
          numberOfResult: limit.to_i,
          fieldsOption: fields_option.to_h
        }
        route(to: :detail_group, query: query, token_id: token_id)
      end

      def routes
        @routes ||= {
          detail_group: Route::new(verb: 'post', url: route_url(:detailGroup), type: Route::TYPES::JSON),
          find_groups: Route::new(verb: 'post', url: route_url(:findGroupsByProperties), type: Route::TYPES::JSON)
        }
      end

      private def route_url(name)
        "/#{self.class.package}/#{name}"
      end
    end
  end
end
