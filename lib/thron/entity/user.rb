require_relative 'capabilities'
require_relative 'preferences'
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
          type: Mappable::Attribute::new(name: 'userType'),
          password_updated_at: Mappable::Attribute::new(name: 'passwordUpdate', type: Mappable::Attribute::TIME),
          created_at: Mappable::Attribute::new(name: 'creationDate', type: Mappable::Attribute::TIME),
          capabilities: Mappable::Attribute::new(name: 'userCapabilities', type: Capabilities),
          active: Mappable::Attribute::new(name: 'active', type: Mappable::Attribute::BOOL),
          expire_at: Mappable::Attribute::new(name: 'expiryDate', type: Mappable::Attribute::DATE),
          preferences: Mappable::Attribute::new(name: 'userPreferences', type: Preferences),
          created_by: Mappable::Attribute::new(name: 'createdBy'),
          picture: Mappable::Attribute::new(name: 'profilePicture', type: Picture),
          acl_rules: Mappable::Attribute::new(name: 'ownAclRules', type: [AclRule]),
          quota: Mappable::Attribute::new(name: 'userQuota', type: Mappable::Attribute::INT),
          lock_template: Mappable::Attribute::new(name: 'userLockTemplate'),
          notify_first_access: Mappable::Attribute::new(name: 'sendFirstAccessNotification', type: Mappable::Attribute::BOOL),
          i_metadata: Mappable::Attribute::new(name: 'imetadata', type: [IMetadata]),
          i_tags: Mappable::Attribute::new(name: 'itags', type: [ITag]),
          external_id: Mappable::Attribute::new(name: 'externalId', type: ExternalId),
          contact_id: Mappable::Attribute::new(name: 'contactId'),
          metadata: Mappable::Attribute::new(name: 'metadata', type: [Metadata]),
          detail: Mappable::Attribute::new(name: 'detail', type: UserDetail),
          credentials: Mappable::Attribute::new(name: 'credential', type: Credentials)
        }
      end
      include Mappable
    end
  end
end
