require_relative 'acl'

module Thron
  module Entity
    class GroupCriteria
      def self.mappings
        @mappings ||= { 
          ids: Mappable::Attribute::new(name: 'ids', type: Mappable::Attribute::LIST),
          keyword: Mappable::Attribute::new(name: 'textSearch'),
          active: Mappable::Attribute::new(name: 'active', type: Mappable::Attribute::BOOL),
          linked_username: Mappable::Attribute::new(name: 'linkedUsername'),
          roles: Mappable::Attribute::new(name: 'groupRoles', type: Mappable::Attribute::LIST),
          solutions: Mappable::Attribute::new(name: 'usersEnabledSolutions', type: Mappable::Attribute::LIST),
          acl: Mappable::Attribute::new(name: 'acl', type: Acl),
          type: Mappable::Attribute::new(name: 'groupType'),
          owner: Mappable::Attribute::new(name: 'ownerUsername'),
          external_id: Mappable::Attribute::new(name: 'externalId', type: ExternalId)
        }
      end
      include Mappable
    end
  end
end
