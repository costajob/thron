require_relative '../behaviour/mappable'

module Thron
  module Entity
    class EmbedCode
      def self.mappings
        @mappings ||= { 
          id: Attribute::new(name: 'id'),
          name: Attribute::new(name: 'name'),
          template_id: Attribute::new(name: 'useTemplateId'),
          target: Attribute::new(name: 'embedTarget'),
          enabled: Attribute::new(name: 'enabled', type: Attribute::BOOL),
          values: Attribute::new(name: 'values', type: [Metadata]),
          ga_tracker: Attribute::new(name: 'trackerGA'),
          context_id: Attribute::new(name: 'useContextId')
        }
      end
      include Mappable
    end
  end
end
