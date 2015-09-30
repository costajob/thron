module Thron
  module Entity
    Patch = Struct::new(:op, :field) do
      def self.default
        new
      end

      alias_method :to_payload, :to_h
    end
  end
end
