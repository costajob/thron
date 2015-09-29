require_relative 'acl'

module Thron
  module Entity
    GroupCriteria = Struct::new(:ids, :keyword, :active, :linked_username, :roles, :solutions, :acl, :type, :owner, :external_id) do
      def self.default
        new([], nil, true, nil, [], [], Acl::default, nil, nil, nil)
      end

      def to_h
        {
          ids: ids,
          textSearch: keyword,
          active: active,
          linkedUsername: linked_username,
          groupRoles: roles,
          usersEnabledSolutions: solutions,
          acl: acl.to_h,
          groupType: type,
          ownerUsername: owner,
          externalId: external_id
        }
      end
    end
  end
end
