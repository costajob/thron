require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Url
      def self.mappings
        @mappings ||= { 
          category: Mappable::Attribute::new('urlCategory'),
          address: Mappable::Attribute::new('url')
        }
      end
      include Mappable
    end
  end
end
