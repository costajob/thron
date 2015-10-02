require_relative '../behaviour/mappable'

module Thron
  module Entity
    class IMetadata
      def self.mappings
        @mappings ||= { 
          classification_id: Mappable::Attribute::new(name: 'classificationId'),
          key: Mappable::Attribute::new(name: 'key'),
          value: Mappable::Attribute::new(name: 'value'),
          lang: Mappable::Attribute::new(name: 'lang'),
          definition_id: Mappable::Attribute::new(name: 'metadataDefinitionId')
        }
      end
      include Mappable
    end
  end
end
