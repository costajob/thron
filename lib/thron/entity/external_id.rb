module Thron
  module Entity
    ExternalId = Struct::new(:id, :type) do
      def self.default
        new
      end

      def to_payload
        {
          id: id,
          externalType: type 
        }
      end
    end
  end
end
