module Thron
  module Entity
    Group = Struct::new(:id, :type, :active, :name, :description, :capabilities, :roles, :solutions) do
      def self.default
        new(nil, nil, false, 'default', nil, [], [], [])
      end

      def to_h
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
        }
      end
    end
  end
end
