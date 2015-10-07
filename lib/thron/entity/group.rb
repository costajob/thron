require_relative 'capabilities'
require_relative 'acl_rule'
require_relative 'i_metadata'
require_relative 'i_tag'
require_relative 'external_id'
require_relative 'metadata'

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
          type: Attribute::new(name: 'type'),
          name: Attribute::new(name: 'name'),
          description: Attribute::new(name: 'description'),
          created_at: Attribute::new(name: 'creationDate', type: Attribute::TIME),
          active: Attribute::new(name: 'active', type: Attribute::BOOL),
          capabilities: Attribute::new(name: 'groupCapabilities', type: Capabilities),
          owner: Attribute::new(name: 'ownerUsername'),
          acl_rules: Attribute::new(name: 'ownAclRules', type: [AclRule]),
          i_metadata: Attribute::new(name: 'imetadata', type: [IMetadata]),
          i_tags: Attribute::new(name: 'itags', type: [ITag]),
          external_id: Attribute::new(name: 'externalId', type: ExternalId),
          metadata: Attribute::new(name: 'metadata', type: [Metadata])
        }
      end
      include Mappable
    end
  end
end
