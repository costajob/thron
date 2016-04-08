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

      def connect_device(options = {})
        device_id = options[:device_id]
        ik = options[:ik]
        contact_name = options[:contact_name]
        body = { 
          clientId: client_id,
          deviceId: device_id,
          ik: ik,
          contactName: contact_name
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end

      def disconnect_device(options = {})
        device_id = options[:device_id]
        contact_id = options[:contact_id]
        body = { 
          clientId: client_id,
          deviceId: device_id,
          contactId: contact_id
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end

      def get_device(options = {})
        device_id = options[:device_id]
        query = { 
          deviceId: device_id,
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end
    end
  end
end
