require_relative 'session'

module Thron
  module Gateway
    class ContentList < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def find(criteria: Entity::Base::new, order_by: nil, limit: 0, offset: 0)
        query = { 
          clientId: self.client_id,
          orderBy: order_by,
          numberOfResult: limit,
          offset: offset
        }.merge(criteria.to_payload)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = response.body.fetch('contents') { [] }.map do |content|
            Entity::Base::new(content)
          end
        end
      end

      def self.routes
        @routes ||= {
          find: Route::factory(name: 'showContents', package: PACKAGE, verb: Route::Verbs::GET)
        }
      end
    end
  end
end
