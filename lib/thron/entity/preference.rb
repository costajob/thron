require_relative 'notification'

module Thron
  module Entity
    class Preference
      def self.mappings
        @mappings ||= { 
          timezone_id: Mappable::Attribute::new('timeZoneId'),
          locale: Mappable::Attribute::new('locale'),
          notification: Mappable::Attribute::new('notificationProperty', Notification),
          default_category_id: Mappable::Attribute::new('defaultCategoryId')
        }
      end
      include Mappable
    end
  end
end
