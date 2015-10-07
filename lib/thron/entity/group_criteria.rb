require_relative 'acl'

module Thron
  module Entity
    class GroupCriteria
      def self.mappings
        @mappings ||= { 
          ids: Attribute::new(name: 'ids', type: Attribute::LIST),
          keyword: Attribute::new(name: 'textSearch'),
          active: Attribute::new(name: 'active', type: Attribute::BOOL),
          linked_username: Attribute::new(name: 'linkedUsername'),
          roles: Attribute::new(name: 'groupRoles', type: Attribute::LIST),
          solutions: Attribute::new(name: 'usersEnabledSolutions', type: Attribute::LIST),
          acl: Attribute::new(name: 'acl', type: Acl),
          type: Attribute::new(name: 'groupType'),
          owner: Attribute::new(name: 'ownerUsername'),
          external_id: Attribute::new(name: 'externalId', type: ExternalId)
        }
      end
      include Mappable
    end
  end
end
