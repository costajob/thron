require_relative 'i_call'
require_relative 'address'
require_relative 'name'
require_relative 'email'
require_relative 'phone'
require_relative 'url'
require_relative 'im_contact'
require_relative 'business_detail'

module Thron
  module Entity
    class UserDetail
      def self.mappings
        @mappings ||= { 
          dob: Attribute::new(name: 'dob'),
          gender: Attribute::new(name: 'gender'),
          contact_type: Attribute::new(name: 'contactType'),
          note: Attribute::new(name: 'note'),
          reference_id: Attribute::new(name: 'externalReferenceId'),
          i_calls: Attribute::new(name: 'icalls', type: [ICall]),
          addresses: Attribute::new(name: 'addresses', type: [Address]),
          picture: Attribute::new(name: 'image', type: Picture),
          name: Attribute::new(name: 'name', type: Name),
          emails: Attribute::new(name: 'emails', type: [Email]),
          phones: Attribute::new(name: 'phoneNumbers', type: [Phone]),
          urls: Attribute::new(name: 'urls', type: [Url]),
          im_contacts: Attribute::new(name: 'imcontacts', type: [ImContact]),
          business_detail: Attribute::new(name: 'businessDetail', type: BusinessDetail)
        }
      end
      include Mappable
    end
  end
end
