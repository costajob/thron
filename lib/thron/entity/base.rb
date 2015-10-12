require 'ostruct'
require 'time'
require_relative '../string_extensions'

module Thron
  using StringExtensions
  module Entity
    class Base < OpenStruct

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
                      else
                        if k.to_s.match(/_date/)
                          Time::parse(v.to_s)
                        else
                          v
                        end
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

      private def fetch_value(value, message)
        case value
        when Base
          value.send(message)
        when Array
          if value.first.is_a?(Base)
            value.map { |entity| entity.send(message) }
          else
            value
          end
        else
          value
        end
      end
    end
  end
end
