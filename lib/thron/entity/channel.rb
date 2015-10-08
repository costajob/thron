require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Channel
      def self.mappings
        @mappings ||= { 
          type: Attribute::new(name: 'channelType'),
          status: Attribute::new(name: 'status')
        }
      end
      include Mappable
    end
  end
end
