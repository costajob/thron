require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Notification
      def self.mappings
        @mappings ||= { 
          email: Mappable::Attribute::new(name: 'email'),
          phone: Mappable::Attribute::new(name: 'phoneNumber'),
          notify_by: Mappable::Attribute::new(name: 'notifyBy', type: Mappable::Attribute::LIST),
          auto_subscription: Mappable::Attribute::new(name: 'autoSubscribeToCategories', type: Mappable::Attribute::BOOL)
        }
      end
      include Mappable
    end
  end
end
