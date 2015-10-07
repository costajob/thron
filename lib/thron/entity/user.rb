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
require_relative 'patch'

module Thron
  module Entity
    class User
      def self.mappings
        @mappings ||= { 
          type: Attribute::new(name: 'userType'),
          password_updated_at: Attribute::new(name: 'passwordUpdate', type: Attribute::TIME),
          created_at: Attribute::new(name: 'creationDate', type: Attribute::TIME),
          capabilities: Attribute::new(name: 'userCapabilities', type: Capabilities),
          active: Attribute::new(name: 'active', type: Attribute::BOOL),
          expire_at: Attribute::new(name: 'expiryDate', type: Attribute::DATE),
          preferences: Attribute::new(name: 'userPreferences', type: Preferences),
          created_by: Attribute::new(name: 'createdBy'),
          picture: Attribute::new(name: 'profilePicture', type: Picture),
          acl_rules: Attribute::new(name: 'ownAclRules', type: [AclRule]),
          quota: Attribute::new(name: 'userQuota', type: Attribute::INT),
          lock_template: Attribute::new(name: 'userLockTemplate'),
          notify_first_access: Attribute::new(name: 'sendFirstAccessNotification', type: Attribute::BOOL),
          i_metadata: Attribute::new(name: 'imetadata', type: [IMetadata]),
          i_tags: Attribute::new(name: 'itags', type: [ITag]),
          external_id: Attribute::new(name: 'externalId', type: ExternalId),
          contact_id: Attribute::new(name: 'contactId'),
          metadata: Attribute::new(name: 'metadata', type: [Metadata]),
          detail: Attribute::new(name: 'detail', type: UserDetail),
          credentials: Attribute::new(name: 'credential', type: Credentials),
          patches: Attribute::new(name: 'patch', type: [Patch])
        }
      end
      include Mappable
    end
  end
end
