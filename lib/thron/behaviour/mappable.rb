require 'date'
require 'time'

module Thron
  module Mappable
    class Attribute
      %w[string int float list date time bool].each do |type|
        const_set(type.upcase, type)
      end

      attr_accessor :name, :type, :mandatory

      def initialize(name:, type: STRING, mandatory: false)
        @name, @type, @mandatory = name, type, mandatory
      end
    end

    class MissingAttributeError < StandardError; end

    module ClassMethods
      def default_value(type)
        case type
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
        else
          nil
        end
      end

      def fetch_value(data:, mapped_attribute:)
        data.fetch(mapped_attribute.name.to_s) do
          fail MissingAttributeError, "Mandatory attribute is missing: #{name}" if mapped_attribute.mandatory
          default_value(mapped_attribute.type)
        end
      end

      def map_value(value:, mapping:)
        return value if value.nil?
        case(type = mapping.type)
        when Array
          entity = type.first
          value.map { |data| entity.factory(data) }
        when Class
          type.factory(value)
        else
          value
        end
      end

      def factory(data)
        args = mappings.reduce({}) do |acc, (attr, mapping)|
          value = fetch_value(data: data, mapped_attribute: mapping)
          acc[attr] = map_value(value: value, mapping: mapping); acc
        end
        new(args)
      end

      def default(args = {})
        args = mappings.reduce({}) do |acc, (attr, mapping)|
          acc[attr] = args.fetch(attr) { default_value(mapping.type) }
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

    def to_h(payload: false)
      self.class.mappings.reduce({}) do |acc, (attr, mapping)|
        value = send(attr)
        key = payload ? mapping.name : attr
        acc[key] = value_by_type(type: mapping.type, value: value, payload: payload)
        acc
      end
    end

    def to_payload
      to_h(payload: true)
    end

    def hash
      @hash ||= instance_variables.reduce(0) do |acc, attr|
        value = self.instance_variable_get(attr)
        code = case value
               when Array
                 value.empty? ? 0 : value.map(&:hash).reduce(&:+)
               else
                 value.hash
               end
        acc += code
      end
    end

    def ==(other)
      self.hash == other.hash
    end

    alias_method :eql?, :==


    private def value_by_type(type:, value:, payload:)
      return value if value.nil?
      case type
      when Array
        value.map { |v| v.to_h(payload: payload) }
      when Class
        value.to_h(payload: payload)
      when Attribute::DATE
        Date::parse(value.to_s).to_s
      when Attribute::TIME
        Time::parse(value.to_s).iso8601
      else
        value
      end
    end
  end
end
