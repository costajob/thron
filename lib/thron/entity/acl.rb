require_relative 'acl_rule'

module Thron
  module Entity
    Acl = Struct::new(:on_context, :rules) do
      def self.default
        new(nil, [])
      end

      def to_payload
        {
          onContext: on_context,
          rules: rules.map(&:to_payload)
        }
      end
    end
  end
end
