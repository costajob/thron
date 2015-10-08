require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Base
      class << self
        attr_writer :type

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
    end
  end
end
