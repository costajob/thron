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

      def create_category(options = {})
        parent_id = options[:parent_id]
        locale = options[:locale]
        is_private = options.fetch(:is_private) { false }
        solution = options[:solution]
        data = options[:data]
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

      def create_system_category(options = {})
        category_id = options[:category_id]
        parent_id = options[:parent_id]
        locale = options[:locale]
        data = options[:data]
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

      def add_category_for_locale(options = {})
        category_id = options[:category_id]
        locale = options[:locale]
        body = { 
          client: {
            clientId: client_id
          },
          catId: category_id,
          catLocale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_category_pretty_id(options = {})
        category_id = options[:category_id]
        pretty_id = options[:pretty_id]
        body = { 
          clientId: client_id,
          categoryId: category_id,
          prettyId: pretty_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def find_categories(options = {})
        criteria = options.fetch(:criteria) { {} }
        locale = options[:locale]
        order_by = options[:order_by]
        offset = options[:offset].to_i
        limit = options[:limit].to_i
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

      def category_detail(options = {})
        category_id = options[:category_id]
        recursive = options.fetch(:recursive) { false }
        locale = options[:locale]
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

      def remove_category(options = {})
        category_id = options[:category_id]
        recursive = options.fetch(:recursive) { false }
        query = { 
          clientId: client_id,
          catId: category_id,
          cascade: recursive
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def remove_category_for_locale(options = {})
        category_id = options[:category_id]
        locale = options[:locale]
        body = { 
          client: {
            clientId: client_id
          },
          catId: category_id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_category_pretty_id(options = {})
        category_id = options[:category_id]
        locale = options[:locale]
        body = { 
          clientId: client_id,
          categoryId: category_id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def set_parent_category(options = {})
        category_id = options[:category_id]
        parent_id = options[:parent_id]
        query = { 
          clientId: client_id,
          categoryId: category_id,
          categoryParentId: parent_id
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def update_category(options = {})
        category_id = options[:category_id]
        data = options[:data]
        body = { 
          client: {
            clientId: client_id
          },
          categoryId: category_id,
          update: data
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_category_for_locale(options = {})
        category_id = options[:category_id]
        locale = options[:locale]
        body = { 
          client: {
            clientId: client_id
          },
          catId: category_id,
          property: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_category_pretty_id(options = {})
        category_id = options[:category_id]
        pretty_id = options[:pretty_id]
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
