require_relative 'mappable'

module Thron
  module SimplyMappable
    module ClassMethods
      def type=(type)
        @type = type
      end

      def type
        @type || Mappable::Attribute::STRING
      end

      def mappings=(args)
        @mappings ||= args.reduce({}) do |acc, attr| 
          acc[attr.to_sym] = Mappable::Attribute::new(name: attr.to_s, type: type); acc
        end
      end

      def mappings
        @mappings
      end
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end
  end
end
