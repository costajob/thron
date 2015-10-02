require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Address
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new(name: 'addressCategory'),
          street: Mappable::Attribute::new(name: 'street'),
          pobox: Mappable::Attribute::new(name: 'pobox'),
          local_area: Mappable::Attribute::new(name: 'localArea'),
          city: Mappable::Attribute::new(name: 'city'),
          area: Mappable::Attribute::new(name: 'area'),
          zip: Mappable::Attribute::new(name: 'postcode'),
          country: Mappable::Attribute::new(name: 'country'),
          primary: Mappable::Attribute::new(name: 'primary', type: Mappable::Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
