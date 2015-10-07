require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Address
      def self.mappings
        @mappings ||= { 
          category: Attribute::new(name: 'addressCategory'),
          street: Attribute::new(name: 'street'),
          pobox: Attribute::new(name: 'pobox'),
          local_area: Attribute::new(name: 'localArea'),
          city: Attribute::new(name: 'city'),
          area: Attribute::new(name: 'area'),
          zip: Attribute::new(name: 'postcode'),
          country: Attribute::new(name: 'country'),
          primary: Attribute::new(name: 'primary', type: Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
