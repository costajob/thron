require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Url
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new(name: 'urlCategory'),
          address: Mappable::Attribute::new(name: 'url')
        }
      end
      include Mappable
    end
  end
end
