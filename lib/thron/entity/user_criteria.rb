require_relative 'acl'
require_relative 'i_tag_op'

module Thron
  module Entity
    class UserCriteria
      def self.mappings
        @mappings ||= { 
          usernames: Attribute::new(name: 'usernames', type: Attribute::LIST),
          types: Attribute::new(name: 'userTypes', type: Attribute::LIST),
          linked_groups: Attribute::new(name: 'linkedGroupsIds', type: Attribute::LIST),
          solutions: Attribute::new(name: 'solutions', type: Attribute::LIST),
          active: Attribute::new(name: 'active', type: Attribute::BOOL),
          roles: Attribute::new(name: 'userRoles', type: Attribute::LIST),
          keyword: Attribute::new(name: 'textSearch'),
          last: Attribute::new(name: 'lastname'),
          first: Attribute::new(name: 'firstname'),
          acl: Attribute::new(name: 'acl', type: Acl),
          i_tag_op: Attribute::new(name: 'itagOp', type: ITagOp),
          phone: Attribute::new(name: 'phoneNumber'),
          email: Attribute::new(name: 'email'),
          created_by: Attribute::new(name: 'createdBy'),
          external_id: Attribute::new(name: 'externalId')
        }
      end
      include Mappable
    end
  end
end
