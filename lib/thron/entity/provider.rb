require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Provider
      def self.mappings
        @mappings ||= { 
          name: Attribute::new(name: 'providerName'),
          url: Attribute::new(name: 'url'),
          published_at: Attribute::new(name: 'publishedDate'),
          status: Attribute::new(name: 'status')
        }
      end
      include Mappable
    end
  end
end
