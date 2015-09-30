module Thron
  module Entity
    Metadata = Struct::new(:name, :value) do
      def self.default
        new
      end

      alias_method :to_payload, :to_h
    end
  end
end
