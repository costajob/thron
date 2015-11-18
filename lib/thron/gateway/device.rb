require 'thron/gateway/session'

module Thron
  module Gateway
    class Device < Session

      base_uri "#{Config::thron::protocol}://#{Config::thron::client_id}-device.thron.com/api"

      PACKAGE = Package.new(:xdevice, :resources, self.service_name)

      def self.routes
        @routes ||= {
          connect_device: Route::factory(name: 'connect', package: PACKAGE),
          disconnect_device: Route::factory(name: 'disconnect', package: PACKAGE),
          get_device: Route::factory(name: 'get', package: PACKAGE, verb: Route::Verbs::GET, params: [client_id])
        }
      end

      def connect_device(device_id:, ik:, contact_name:)
        body = { 
          clientId: client_id,
          deviceId: device_id,
          ik: ik,
          contactName: contact_name
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end

      def disconnect_device(device_id:, contact_id:)
        body = { 
          clientId: client_id,
          deviceId: device_id,
          contactId: contact_id
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end

      def get_device(device_id: nil)
        query = { 
          deviceId: device_id,
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end
    end
  end
end
