require_relative 'notification'

module Thron
  module Entity
    class Preferences
      def self.mappings
        @mappings ||= { 
          timezone_id: Attribute::new(name: 'timeZoneId'),
          locale: Attribute::new(name: 'locale'),
          notification: Attribute::new(name: 'notificationProperty', type: Notification),
          default_category_id: Attribute::new(name: 'defaultCategoryId')
        }
      end
      include Mappable
    end
  end
end
