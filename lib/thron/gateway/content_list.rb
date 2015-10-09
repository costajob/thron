require_relative 'session'

module Thron
  module Gateway
    class ContentList < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def find(criteria:, order_by: nil, limit: 0, offset: 0)
        query = criteria.to_payload.merge({ 
          clientId: self.client_id,
          orderBy: order_by,
          numberOfResult: limit,
          offset: offset
        })
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.mapped = response.body.fetch('contents') { [] }.map do |content|
            Entity::new(content)
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
