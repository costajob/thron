require_relative 'metadata'
require_relative 'patch'
require_relative 'external_id'
require_relative 'acl_rule'

module Thron
  module Entity
    Group = Struct::new(:id, :external_id, :type, :active, :name, :description, :owner, :acl_rules, :capabilities, :roles, :solutions, :metadata, :patches) do
      attr_reader :created_at

      def initialize(*args)
        @created_at = Time::now
        super
      end

      def self.default
        new(nil, nil, nil, false, 'default', nil, nil, [], [], [], [], [], [])
      end

      def to_payload
        {
          groupType: type,
          active: active,
          groupCapabilities: {
            capabilities: capabilities,
            userRoles: roles,
            enabledSolutions: solutions
          },
          description: description,
          name: name,
          metadata: metadata.map(&:to_payload),
          patch: patches.map(&:to_payload)
        }
      end
    end
  end
end
