require_relative 'notification'

module Thron
  module Entity
    class Preferences
      def self.mappings
        @mappings ||= { 
          timezone_id: Mappable::Attribute::new(name: 'timeZoneId'),
          locale: Mappable::Attribute::new(name: 'locale'),
          notification: Mappable::Attribute::new(name: 'notificationProperty', type: Notification),
          default_category_id: Mappable::Attribute::new(name: 'defaultCategoryId')
        }
      end
      include Mappable
    end
  end
end
