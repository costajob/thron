require_relative 'capabilities'
require_relative 'preference'
require_relative 'picture'
require_relative 'acl_rule'
require_relative 'i_metadata'
require_relative 'i_tag'
require_relative 'external_id'
require_relative 'metadata'
require_relative 'user_detail'
require_relative 'credentials'

module Thron
  module Entity
    class User
      def self.mappings
        @mappings ||= { 
          type: Mappable::Attribute::new('type'),
          password_updated_at: Mappable::Attribute::new('passwordUpdate', Mappable::Attribute::TIME),
          created_at: Mappable::Attribute::new('creationDate', Mappable::Attribute::TIME),
          capabilities: Mappable::Attribute::new('userCapabilities', Capabilities),
          active: Mappable::Attribute::new('active', Mappable::Attribute::BOOL),
          expiration_at: Mappable::Attribute::new('expiryDate', Mappable::Attribute::DATE),
          preferences: Mappable::Attribute::new('userPreferences', [Preference]),
          created_by: Mappable::Attribute::new('createdBy'),
          picture: Mappable::Attribute::new('profilePicture', Picture),
          acl_rules: Mappable::Attribute::new('ownAclRules', [AclRule]),
          quota: Mappable::Attribute::new('userQuota', Mappable::Attribute::INT),
          lock_template: Mappable::Attribute::new('userLockTemplate'),
          i_metadata: Mappable::Attribute::new('imetadata', [IMetadata]),
          i_tags: Mappable::Attribute::new('itags', [ITag]),
          external_id: Mappable::Attribute::new('externalId', ExternalId),
          contact_id: Mappable::Attribute::new('contactId'),
          metadata: Mappable::Attribute::new('metadata', [Metadata]),
          detail: Mappable::Attribute::new('detail', UserDetail),
          credentials: Mappable::Attribute::new('credential', Credentials)
        }
      end
      include Mappable
    end
  end
end
