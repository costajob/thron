require 'ostruct'

module Thron
  module Entity
    class Plain < OpenStruct
      class << self
        alias_method :factory, :new
      end 

      def initialize(hash = nil)
        @hash_table = {}
        if hash
          hash.each do |k,v|
            @hash_table[k.to_sym] = v
            new_ostruct_member(k)
          end
        end
      end

      def to_h(*args)
        @hash_table
      end

      alias_method :to_payload, :to_h
    end
  end
end
