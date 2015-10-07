require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Notification
      def self.mappings
        @mappings ||= { 
          email: Attribute::new(name: 'email'),
          phone: Attribute::new(name: 'phoneNumber'),
          notify_by: Attribute::new(name: 'notifyBy', type: Attribute::LIST),
          auto_subscription: Attribute::new(name: 'autoSubscribeToCategories', type: Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
