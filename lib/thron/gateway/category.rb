require 'thron/gateway/session'

module Thron
  module Gateway
    class Category < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      paginate :find_categories

      def self.routes
        @routes ||= {
          create_category: Route::factory(name: 'createCategory', package: PACKAGE),
          create_system_category: Route::factory(name: 'createSystemCategory', package: PACKAGE),
          add_category_for_locale: Route::factory(name: 'addCategory4Locale', package: PACKAGE),
          add_category_pretty_id: Route::factory(name: 'addCategoryPrettyId', package: PACKAGE),
          find_categories: Route::factory(name: 'findByProperties2', package: PACKAGE),
          category_detail: Route::factory(name: 'getCategory', package: PACKAGE, verb: Route::Verbs::GET),
          remove_category: Route::factory(name: 'removeCategory', package: PACKAGE),
          remove_category_for_locale: Route::factory(name: 'removeCategory4Locale', package: PACKAGE),
          remove_category_pretty_id: Route::factory(name: 'removeCategoryPrettyId', package: PACKAGE),
          set_parent_category: Route::factory(name: 'setParentId', package: PACKAGE),
          update_category: Route::factory(name: 'updateCategory', package: PACKAGE),
          update_category_for_locale: Route::factory(name: 'updateCategory4Locale', package: PACKAGE),
          update_category_pretty_id: Route::factory(name: 'updateCategoryPrettyId', package: PACKAGE)
        }
      end

      def create_category(parent_id:, locale:, is_private: false, solution: nil, data:)
        body = { 
          client: {
            clientId: client_id
          },
          upCatId: parent_id,
          catLocales: locale,
          isPrivate: is_private,
          private: is_private,
          solution: solution,
          options: data
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_system_category(category_id:, parent_id:, locale:, data:)
        body = { 
          client: {
            clientId: client_id
          },
          newCategoryId: category_id,
          upCatId: parent_id,
          catLocales: locale,
          options: data
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_category_for_locale(category_id:, locale:)
        body = { 
          client: {
            clientId: client_id
          },
          catId: category_id,
          catLocale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_category_pretty_id(category_id:, pretty_id:)
        body = { 
          clientId: client_id,
          categoryId: category_id,
          prettyId: pretty_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def find_categories(criteria: {}, locale: nil, order_by: nil, offset: 0, limit: 0)
        body = { 
          client: {
            clientId: client_id
          },
          properties: criteria,
          locale: locale,
          orderBy: order_by,
          offset: offset.to_i,
          numberOfResult: limit.to_i
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('categories') { [] })
        end
      end

      def category_detail(category_id:, recursive: false, locale: nil)
        query = { 
          clientId: client_id,
          categoryId: category_id,
          cascade: recursive,
          locale: locale
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('category') { {} })
        end
      end

      def remove_category(category_id:, recursive: false)
        query = { 
          clientId: client_id,
          catId: category_id,
          cascade: recursive
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def remove_category_for_locale(category_id:, locale:)
        body = { 
          client: {
            clientId: client_id
          },
          catId: category_id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_category_pretty_id(category_id:, locale:)
        body = { 
          clientId: client_id,
          categoryId: category_id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def set_parent_category(category_id:, parent_id:)
        query = { 
          clientId: client_id,
          categoryId: category_id,
          categoryParentId: parent_id
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def update_category(category_id:, data:)
        body = { 
          client: {
            clientId: client_id
          },
          categoryId: category_id,
          update: data
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_category_for_locale(category_id:, locale:)
        body = { 
          client: {
            clientId: client_id
          },
          catId: category_id,
          property: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_category_pretty_id(category_id:, pretty_id:)
        body = { 
          clientId: client_id,
          categoryId: category_id,
          prettyId: pretty_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end
    end
  end
end
