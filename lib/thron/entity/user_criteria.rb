require_relative 'acl'
require_relative 'i_tag_op'

module Thron
  module Entity
    class UserCriteria
      def self.mappings
        @mappings ||= { 
          usernames: Mappable::Attribute::new(name: 'usernames', type: Mappable::Attribute::LIST),
          types: Mappable::Attribute::new(name: 'userTypes', type: Mappable::Attribute::LIST),
          linked_groups: Mappable::Attribute::new(name: 'linkedGroupsIds', type: Mappable::Attribute::LIST),
          solutions: Mappable::Attribute::new(name: 'solutions', type: Mappable::Attribute::LIST),
          active: Mappable::Attribute::new(name: 'active', type: Mappable::Attribute::BOOL),
          roles: Mappable::Attribute::new(name: 'userRoles', type: Mappable::Attribute::LIST),
          keyword: Mappable::Attribute::new(name: 'textSearch'),
          last: Mappable::Attribute::new(name: 'lastname'),
          first: Mappable::Attribute::new(name: 'firstname'),
          acl: Mappable::Attribute::new(name: 'acl', type: Acl),
          i_tag_op: Mappable::Attribute::new(name: 'itagOp', type: ITagOp),
          phone: Mappable::Attribute::new(name: 'phoneNumber'),
          email: Mappable::Attribute::new(name: 'email'),
          created_by: Mappable::Attribute::new(name: 'createdBy'),
          external_id: Mappable::Attribute::new(name: 'externalId')
        }
      end
      include Mappable
    end
  end
end
