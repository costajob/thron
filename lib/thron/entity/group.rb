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
          id: Mappable::Attribute::new(name: 'id'),
          type: Mappable::Attribute::new(name: 'type'),
          name: Mappable::Attribute::new(name: 'name'),
          description: Mappable::Attribute::new(name: 'description'),
          created_at: Mappable::Attribute::new(name: 'creationDate', type: Mappable::Attribute::TIME),
          active: Mappable::Attribute::new(name: 'active', type: Mappable::Attribute::BOOL),
          capabilities: Mappable::Attribute::new(name: 'groupCapabilities', type: Capabilities),
          owner: Mappable::Attribute::new(name: 'ownerUsername'),
          acl_rules: Mappable::Attribute::new(name: 'ownAclRules', type: [AclRule]),
          i_metadata: Mappable::Attribute::new(name: 'imetadata', type: [IMetadata]),
          i_tags: Mappable::Attribute::new(name: 'itags', type: [ITag]),
          external_id: Mappable::Attribute::new(name: 'externalId', type: ExternalId),
          metadata: Mappable::Attribute::new(name: 'metadata', type: [Metadata])
        }
      end
      include Mappable
    end
  end
end
