require 'thron/gateway/session'

module Thron
  module Gateway
    class ContentList < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      paginate :show_contents

      def self.routes
        @routes ||= {
          show_contents: Route::factory(name: 'showContents', package: PACKAGE, verb: Route::Verbs::GET)
        }
      end

      def show_contents(options = {})
        category_id = options[:category_id]
        locale = options[:locale]
        criteria = options.fetch(:criteria) { {} }
        recursive = options.fetch(:recursive) { true }
        order_by = options.fetch(:order_by) { 'contentName_A' }
        limit = options[:limit].to_i
        offset = options[:offset].to_i
        query = { 
          clientId: client_id,
          categoryId: category_id,
          locale: locale,
          searchOnSubCategories: recursive,
          orderBy: order_by,
          numberOfResult: limit,
          offset: offset
        }.merge(criteria)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('contents') { [] })
        end
      end
    end
  end
end
