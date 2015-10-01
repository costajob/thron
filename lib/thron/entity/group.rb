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
          id: Mappable::Attribute::new('id'),
          type: Mappable::Attribute::new('type'),
          name: Mappable::Attribute::new('name'),
          description: Mappable::Attribute::new('description'),
          created_at: Mappable::Attribute::new('creationDate', Mappable::Attribute::TIME),
          active: Mappable::Attribute::new('active', Mappable::Attribute::BOOL),
          capabilities: Mappable::Attribute::new('groupCapabilities', Capabilities),
          owner: Mappable::Attribute::new('ownerUsername'),
          acl_rules: Mappable::Attribute::new('ownAclRules', [AclRule]),
          i_metadata: Mappable::Attribute::new('imetadata', [IMetadata]),
          i_tags: Mappable::Attribute::new('itags', [ITag]),
          external_id: Mappable::Attribute::new('externalId', ExternalId),
          metadata: Mappable::Attribute::new('metadata', [Metadata])
        }
      end
      include Mappable
    end
  end
end
