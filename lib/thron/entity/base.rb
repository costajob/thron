require 'ostruct'
require 'time'
require 'thron/string_extensions'

module Thron
  using StringExtensions
  module Entity
    class Base < OpenStruct
      TIME_REGEX = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.+/
      DATE_REGEX = /\A\d{4}-\d{2}-\d{2}/

      def self.factory(args)
        case args
        when Hash
          new(args)
        when Array
          args.map { |data| new(data) }
        end
      end

      def initialize(hash = {})
        @table = {}
        hash.each do |k,v|
          k = k.to_s.snakecase.to_sym
          @table[k] = case v
                      when Hash
                        self.class.new(v)
                      when Array
                        if v.first.is_a?(Hash)
                          v.map { |e| self.class.new(e) }
                        else
                          v
                        end
                      when TIME_REGEX
                        Time::parse(v)
                      when DATE_REGEX
                        Date::parse(v)
                      else
                        v
                      end
          new_ostruct_member(k)
        end
      end

      def to_h
        self.each_pair.reduce({}) do |acc, (k,v)|
          acc[k] = fetch_value(v, :to_h); acc
        end
      end

      def to_payload
        self.each_pair.reduce({}) do |acc, (k,v)|
          k = k.to_s.camelize_low
          acc[k] = fetch_value(v, :to_payload); acc
        end
      end

      private
      
      def fetch_value(value, message)
        case value
        when Base
          value.send(message)
        when Array
          if value.first.is_a?(Base)
            value.map { |entity| entity.send(message) }
          else
            value
          end
        when Date, Time
          value.iso8601
        else
          value
        end
      end
    end
  end
end
