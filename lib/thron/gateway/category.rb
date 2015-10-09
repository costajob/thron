require_relative 'session'
require_relative '../entity/category'
require_relative '../entity/category_criteria'

module Thron
  module Gateway
    class Category < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def add_locale(id:, locale: Entity::Plain::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          catLocale: locale.to_payload
        }
        route(to: __callee__, body: body, token_id: @token_id)
      end

      def find(criteria: Entity::CategoryCriteria::new(limit_level: 2), locale: nil, order_by: nil, offset: 0, limit: 0)
        body = { 
          client: {
            clientId: self.client_id
          },
          properties: criteria.to_payload,
          locale: locale,
          orderBy: order_by,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: @token_id) do |response|
          response.mapped = response.body.fetch('categories') { [] }.map do |category|
            detail = category.delete('category') { {} }
            Entity::Category::factory(category.merge!(detail))
          end
        end
      end

      def routes
        @routes ||= {
          add_locale: Route::factory(name: 'createCategory4Locale', package: PACKAGE),
          find: Route::factory(name: 'findByProperties2', package: PACKAGE)
        }
      end
    end
  end
end
