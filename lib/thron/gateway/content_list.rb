require_relative 'session'

module Thron
  module Gateway
    class ContentList < Session

      paginate :show_contents

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def self.routes
        @routes ||= {
          show_contents: Route::factory(name: 'showContents', package: PACKAGE, verb: Route::Verbs::GET)
        }
      end

      def show_contents(category_id:, locale: nil, criteria: Entity::Base::new, recursive: true, order_by: 'contentName_A', limit: 0, offset: 0)
        query = { 
          clientId: self.client_id,
          categoryId: category_id,
          locale: locale,
          searchOnSubCategories: recursive,
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
    end
  end
end
