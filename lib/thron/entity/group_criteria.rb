require_relative 'acl'

module Thron
  module Entity
    class GroupCriteria
      def self.mappings
        @mappings ||= { 
          ids: Mappable::Attribute::new('ids', Mappable::Attribute::LIST),
          keyword: Mappable::Attribute::new('textSearch'),
          active: Mappable::Attribute::new('active', Mappable::Attribute::BOOL),
          linked_username: Mappable::Attribute::new('linkedUsername'),
          groupRoles: Mappable::Attribute::new('roles', Mappable::Attribute::LIST),
          solutions: Mappable::Attribute::new('usersEnabledSolutions', Mappable::Attribute::LIST),
          acl: Mappable::Attribute::new('acl', Acl),
          type: Mappable::Attribute::new('groupType'),
          owner: Mappable::Attribute::new('ownerUsername'),
          external_id: Mappable::Attribute::new('externalId', ExternalId)
        }
      end
      include Mappable
    end
  end
end
