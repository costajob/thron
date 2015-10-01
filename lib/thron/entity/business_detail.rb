require_relative '../behaviour/mappable'

module Thron
  module Entity
    class BusinessDetail
      def self.mappings
        @mappings ||= { 
          company: Mappable::Attribute::new('companyName'),
          city: Mappable::Attribute::new('city'),
          country: Mappable::Attribute::new('country')
        }
      end
      include Mappable
    end
  end
end
