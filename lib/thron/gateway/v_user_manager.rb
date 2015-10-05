require_relative 'session'
require_relative '../entity/user'

module Thron
  module Gateway
    class VUserManager < Session

      PACKAGE      = Package.new(:xsso, :resources, self.service_name)
      DEFAULT_TYPE = 'PLATFORM_USER'

      def create(user: Entity::User::default(type: DEFAULT_TYPE))
        body = user.to_payload.tap do |payload|
          payload['newUser'] = payload.delete('credential')
        end.merge({ clientId: self.client_id })
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          return Entity::User::factory(response.body.fetch('user') { {} })
        end
      end

      def routes
        @routes ||= {
          create: Route::factory(name: 'create', package: PACKAGE)
        }
      end
    end
  end
end
