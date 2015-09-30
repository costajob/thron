require_relative 'metadata'
require_relative 'patch'

module Thron
  module Entity
    Group = Struct::new(:id, :type, :active, :name, :description, :capabilities, :roles, :solutions, :metadata, :patches) do
      def self.default
        new(nil, nil, false, 'default', nil, [], [], [], [], [])
      end

      def to_payload(update = false)
        {
          groupType: type,
          active: active,
          groupCapabilities: {
            capabilities: capabilities,
            userRoles: roles,
            enabledSolutions: solutions
          },
          description: description,
          name: name
        }.tap do |payload|
          payload.merge!(update_payload) if update
        end
      end

      private def update_payload
        {
          metadata: metadata.map(&:to_payload),
          patch: patches.map(&:to_payload)
        }
      end
    end
  end
end
