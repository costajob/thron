require_relative 'channel'

module Thron
  module Entity
    class Weebo
      def self.mappings
        @mappings ||= { 
          content_id: Attribute::new(name: 'pContentId'),
          channels: Attribute::new(name: 'channels'),
          weebo_channels: Attribute::new(name: 'weeboChannels', type: [Channel]),
          weebo_thumb_channels: Attribute::new(name: 'weeboThumbChannels', type: [Channel]),
          published_at: Attribute::new(name: 'publishedDate', type: Attribute::TIME),
          status: Attribute::new(name: 'status')
        }
      end
      include Mappable
    end
  end
end
