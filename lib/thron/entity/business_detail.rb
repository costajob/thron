require_relative '../behaviour/mappable'

module Thron
  module Entity
    class BusinessDetail
      def self.mappings
        @mappings ||= { 
          company: Mappable::Attribute::new(name: 'companyName'),
          city: Mappable::Attribute::new(name: 'city'),
          country: Mappable::Attribute::new(name: 'country')
        }
      end
      include Mappable
    end
  end
end
