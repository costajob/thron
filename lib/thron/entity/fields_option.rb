module Thron
  module Entity
    FieldsOption = Struct::new(:own_acl, :tags, :metadata) do
      def self.default
        new(false, false, false)
      end

      def to_payload
        {
          returnOwnAcl: own_acl,
          returnItags: tags,
          returnImetadata: metadata
        }
      end
    end
  end
end
