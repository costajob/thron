require_relative '../behaviour/mappable'

module Thron
  module Entity
    class IMetadata
      def self.mappings
        @mappings ||= { 
          classification_id: Mappable::Attribute::new('classificationId'),
          key: Mappable::Attribute::new('key'),
          value: Mappable::Attribute::new('value'),
          lang: Mappable::Attribute::new('lang'),
          definition_id: Mappable::Attribute::new('metadataDefinitionId')
        }
      end
      include Mappable
    end
  end
end
