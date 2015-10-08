require_relative '../behaviour/mappable'

module Thron
  module Entity
    class UserValues
      def self.mappings
        @mappings ||= { 
          notifications_subscribed: Attribute::new(name: 'userSubscribedForNotification', type: Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
