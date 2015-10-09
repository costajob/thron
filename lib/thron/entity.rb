require 'ostruct'
require 'date'
require_relative 'string_extensions'

module Thron
  using StringExtensions
  class Entity < OpenStruct

    def initialize(hash = {})
      @table = {}
      hash.each do |k,v|
        k = k.to_s.snakecase.to_sym
        @table[k] = case v
                    when Hash
                      self.class.new(v)
                    else
                      if k.to_s.match(/_date/)
                        Date::parse(v.to_s)
                      else
                        v
                      end
                    end
        new_ostruct_member(k)
      end
    end

    def to_h
      self.each_pair.reduce({}) do |acc, (k,v)|
        acc[k] = case v
                 when Entity
                   v.to_h
                 else
                   v
                 end
        acc
      end
    end

    def to_payload
      self.each_pair.reduce({}) do |acc, (k,v)|
        k = k.to_s.camelize_low
        acc[k] = case v
                 when Entity
                   v.to_payload
                 else
                   v
                 end
        acc
      end
    end
  end
end
