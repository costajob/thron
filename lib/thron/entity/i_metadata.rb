require_relative '../behaviour/mappable'

module Thron
  module Entity
    class IMetadata
      def self.mappings
        @mappings ||= { 
          classification_id: Attribute::new(name: 'classificationId'),
          key: Attribute::new(name: 'key'),
          value: Attribute::new(name: 'value'),
          lang: Attribute::new(name: 'lang'),
          definition_id: Attribute::new(name: 'metadataDefinitionId')
        }
      end
      include Mappable
    end
  end
end
