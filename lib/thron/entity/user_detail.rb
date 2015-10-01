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
          dob: Mappable::Attribute::new('dob'),
          gender: Mappable::Attribute::new('gender'),
          contact_type: Mappable::Attribute::new('contactType'),
          note: Mappable::Attribute::new('note'),
          reference_id: Mappable::Attribute::new('externalReferenceId'),
          i_calls: Mappable::Attribute::new('icalls', [ICall]),
          addresses: Mappable::Attribute::new('addresses', [Address]),
          picture: Mappable::Attribute::new('image', Picture),
          name: Mappable::Attribute::new('name', Name),
          emails: Mappable::Attribute::new('emails', [Email]),
          phones: Mappable::Attribute::new('phoneNumbers', [Phone]),
          urls: Mappable::Attribute::new('urls', [Url]),
          im_contacts: Mappable::Attribute::new('imcontacts', [ImContact]),
          business_detail: Mappable::Attribute::new('businessDetail', BusinessDetail)
        }
      end
      include Mappable
    end
  end
end
