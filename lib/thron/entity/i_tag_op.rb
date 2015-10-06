require_relative 'i_tag'

module Thron
  module Entity
    class ITagOp
      def self.mappings
        @mappings ||= { 
          i_tags: Mappable::Attribute::new(name: 'itags', type: [ITag]),
          operation: Mappable::Attribute::new(name: 'operation')
        }
      end
      include Mappable
    end
  end
end