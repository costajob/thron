require 'date'

module Thron
  module Mappable
    class Attribute
      %w[string int float list date time bool].each do |type|
        const_set(type.upcase, type)
      end

      attr_accessor :name, :type  

      def initialize(name, type = STRING)
        @name, @type = name, type
      end
    end

    module ClassMethods
      def factory(data)
        args = mappings.reduce({}) do |acc, (attr, mapping)|
          value = data.fetch(mapping.name.to_s)
          acc[attr] = case(type = mapping.type)
                      when Array
                        entity = type.first
                        value.map { |data| entity.factory(data) }
                      when Class
                        type.factory(value)
                      else
                        value
                      end
          acc
        end
        new(args)
      end

      def default(args = {})
        args = mappings.reduce({}) do |acc, (attr, mapping)|
          acc[attr] = args.fetch(attr) { 
            case(type = mapping.type)
            when Attribute::INT
              0
            when Attribute::FLOAT
              0.0
            when Attribute::LIST, Array
              []
            when Attribute::DATE
              Date::today
            when Attribute::TIME
              Time::now
            when Attribute::BOOL
              false
            when Class
              type.default
            else
              nil
            end
          }
          acc
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
        value = send(attr)
        acc[mapping.name] = case(type = mapping.type)
                            when Array
                              value.map(&:to_payload)
                            when Class
                              value.to_payload
                            else
                              value
                            end
        acc
      end
    end
  end
end
