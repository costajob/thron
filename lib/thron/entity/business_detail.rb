require_relative '../behaviour/mappable'

module Thron
  module Entity
    class BusinessDetail
      def self.mappings
        @mappings ||= { 
          company: Attribute::new(name: 'companyName'),
          city: Attribute::new(name: 'city'),
          country: Attribute::new(name: 'country')
        }
      end
      include Mappable
    end
  end
end
