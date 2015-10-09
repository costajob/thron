require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Group
      attr_reader :created_at

      def initialize(*args)
        @created_at = Time::now
        super
      end
      
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'id'),
          type: Attribute::new(name: 'groupType'),
          name: Attribute::new(name: 'name'),
          description: Attribute::new(name: 'description'),
          created_at: Attribute::new(name: 'creationDate', type: Attribute::TIME),
          active: Attribute::new(name: 'active', type: Attribute::BOOL),
          capabilities: Attribute::new(name: 'groupCapabilities', type: :Capabilities),
          owner: Attribute::new(name: 'ownerUsername'),
          acl_rules: Attribute::new(name: 'ownAclRules', type: [:AclRule]),
          i_metadata: Attribute::new(name: 'imetadata', type: [:IMetadata]),
          i_tags: Attribute::new(name: 'itags', type: [:ITag]),
          external_id: Attribute::new(name: 'externalId', type: :ExternalId),
          metadata: Attribute::new(name: 'metadata', type: [:Plain]),
          linked_users_count: Attribute::new(name: 'totalLinkedUsers', type: Attribute::INT),
          linked_users: Attribute::new(name: 'linkedUsers', type: [:User])
        }
      end
      include Mappable
    end
  end
end
