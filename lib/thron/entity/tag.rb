require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Tag
      def self.mappings
        @mappings ||= { 
          value: Attribute::new(name: 'value'),
          user_id: Attribute::new(name: 'userId'),
          status: Attribute::new(name: 'status')
        }
      end
      include Mappable
    end
  end
end
