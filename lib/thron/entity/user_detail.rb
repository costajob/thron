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
          dob: Mappable::Attribute::new(name: 'dob'),
          gender: Mappable::Attribute::new(name: 'gender'),
          contact_type: Mappable::Attribute::new(name: 'contactType'),
          note: Mappable::Attribute::new(name: 'note'),
          reference_id: Mappable::Attribute::new(name: 'externalReferenceId'),
          i_calls: Mappable::Attribute::new(name: 'icalls', type: [ICall]),
          addresses: Mappable::Attribute::new(name: 'addresses', type: [Address]),
          picture: Mappable::Attribute::new(name: 'image', type: Picture),
          name: Mappable::Attribute::new(name: 'name', type: Name),
          emails: Mappable::Attribute::new(name: 'emails', type: [Email]),
          phones: Mappable::Attribute::new(name: 'phoneNumbers', type: [Phone]),
          urls: Mappable::Attribute::new(name: 'urls', type: [Url]),
          im_contacts: Mappable::Attribute::new(name: 'imcontacts', type: [ImContact]),
          business_detail: Mappable::Attribute::new(name: 'businessDetail', type: BusinessDetail)
        }
      end
      include Mappable
    end
  end
end
