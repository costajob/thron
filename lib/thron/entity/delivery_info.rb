require_relative 'metadata'

module Thron
  module Entity
    class DeliveryInfo
      def self.mappings
        @mappings ||= { 
          channel_type: Attribute::new(name: 'channelType'),
          thumbs_urls: Attribute::new(name: 'thumbsUrl', type: Attribute::LIST),
          default_thumb_url: Attribute::new(name: 'defaultThumbUrl'),
          best_thumb_url: Attribute::new(name: 'bestThumbUrl'),
          content_descriptor_url: Attribute::new(name: 'contentDescriptorUrl'),
          content_url: Attribute::new(name: 'contentUrl'),
          sys_metadata: Attribute::new(name: 'sysMetadata', type: [Metadata])
        }
      end
      include Mappable
    end
  end
end
