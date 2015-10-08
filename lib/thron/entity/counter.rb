require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Counter
      def self.mappings
        @mappings ||= { 
          value: Attribute::new(name: 'counter', type: Attribute::INT),
          last_view_at: Attribute::new(name: 'lastView', type: Attribute::TIME)
        }
      end
      include Mappable
    end
  end
end
