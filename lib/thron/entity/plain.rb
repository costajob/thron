require 'ostruct'

module Thron
  module Entity
    class Plain
      class << self
        alias_method :factory, :new
      end

      def initialize(hash = {})
        @inner = OpenStruct::new(hash)
      end

      def to_h(*args)
        @inner.to_h
      end

      def to_s
        @inner.to_s
      end

      alias_method :to_payload, :to_h
      alias_method :inspect, :to_s

      def method_missing(name, *args, &block)
        @inner.send(name, *args, &block)
      end
    end
  end
end
