require_relative '../behaviour/mappable'

module Thron
  module Entity
    class ITagOp
      def self.mappings
        @mappings ||= { 
          i_tags: Attribute::new(name: 'itags', type: [:ITag]),
          operation: Attribute::new(name: 'operation')
        }
      end
      include Mappable
    end
  end
end
