require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Address
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new('addressCategory'),
          street: Mappable::Attribute::new('street'),
          pobox: Mappable::Attribute::new('pobox'),
          local_area: Mappable::Attribute::new('localArea'),
          city: Mappable::Attribute::new('city'),
          area: Mappable::Attribute::new('area'),
          zip: Mappable::Attribute::new('postcode'),
          country: Mappable::Attribute::new('country'),
          primary: Mappable::Attribute::new('primary', Mappable::Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
