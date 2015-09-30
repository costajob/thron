module Thron
  module Entity
    Acl = Struct::new(:on_context, :rules) do
      def self.default
        new(nil, [])
      end

      def to_payload
        {
          onContext: on_context,
          rules: rules
        }
      end
    end
  end
end
