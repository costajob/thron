module Thron
  module Mappable
    module ClassMethods
      def factory(data)
        args = mappings.reduce({}) do |acc, (attr, mapping)|
          acc[attr] = data.fetch(mapping); acc
        end
        new(args)
      end
    end

    def self.included(klass)
      klass.extend(ClassMethods)
      klass.send(:attr_accessor, *klass.mappings.keys)
    end

    def initialize(args)
      self.class.mappings.keys.each do |attr|
        instance_variable_set(:"@#{attr}", args.fetch(attr))
      end
    end

    def to_payload
      self.class.mappings.reduce({}) do |acc, (attr, mapping)|
        acc[mapping.to_sym] = send(attr); acc
      end
    end
  end
end
