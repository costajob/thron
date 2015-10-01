require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Notification
      def self.mappings
        @mappings ||= { 
          email: Mappable::Attribute::new('email'),
          phone: Mappable::Attribute::new('phoneNumber'),
          notify_by: Mappable::Attribute::new('notifyBy', Mappable::Attribute::LIST),
          auto_subscription: Mappable::Attribute::new('autoSubscribeToCategories', Mappable::Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
