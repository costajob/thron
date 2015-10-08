require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ResultsOption
      def self.mappings
        @mappings ||= { 
          offset: Attribute::new(name: 'offset', type: Attribute::INT),
          limit: Attribute::new(name: 'numberOfResult', type: Attribute::INT),
          order_by: Attribute::new(name: 'orderBy')
        }
      end
      include Mappable
    end
  end
end
