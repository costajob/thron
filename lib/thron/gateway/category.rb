require_relative 'session'

module Thron
  module Gateway
    class Category < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def self.routes
        @routes ||= {
          create_category: Route::factory(name: 'createCategory', package: PACKAGE),
          create_system_category: Route::factory(name: 'createSystemCategory', package: PACKAGE),
          create_category_locale: Route::factory(name: 'addCategory4Locale', package: PACKAGE),
          create_category_pretty_id: Route::factory(name: 'addCategoryPrettyId', package: PACKAGE),
          find_categories: Route::factory(name: 'findByProperties2', package: PACKAGE),
          category_detail: Route::factory(name: 'getCategory', package: PACKAGE, verb: Route::Verbs::GET),
          remove_category: Route::factory(name: 'removeCategory', package: PACKAGE),
          remove_category_locale: Route::factory(name: 'removeCategory4Locale', package: PACKAGE),
          remove_category_pretty_id: Route::factory(name: 'removeCategoryPrettyId', package: PACKAGE),
          set_parent_category: Route::factory(name: 'setParentId', package: PACKAGE),
          update_category: Route::factory(name: 'updateCategory', package: PACKAGE),
          update_category_locale: Route::factory(name: 'updateCategory4Locale', package: PACKAGE),
          update_category_pretty_id: Route::factory(name: 'updateCategoryPrettyId', package: PACKAGE)
        }
      end

      def create_category(parent_id:, locale: Entity::Base::new, is_private: false, solution: nil, data: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          upCatId: parent_id,
          catLocales: locale.to_payload,
          isPrivate: is_private,
          private: is_private,
          solution: solution,
          options: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_system_category(id:, parent_id:, locale: Entity::Base::new, data: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          newCategoryId: id,
          upCatId: parent_id,
          catLocales: locale.to_payload,
          options: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_category_locale(id:, locale: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          catLocale: locale.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_category_pretty_id(id:, pretty_id:)
        body = { 
          clientId: self.client_id,
          categoryId: id,
          prettyId: pretty_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def find_categories(args = {})
        fetch_paginator(:_find, args)
      end

      private def _find(criteria: Entity::Base::new, locale: nil, order_by: nil, offset: 0, limit: 0)
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
        route(to: :find_categories, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('categories') { [] }.map do |category|
            detail = category.delete('category') { {} }
            Entity::Base::new(category.merge!(detail))
          end
        end
      end

      def category_detail(id:, recursive: false, locale: nil)
        query = { 
          clientId: self.client_id,
          categoryId: id,
          cascade: recursive,
          locale: locale
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('category') { {} })
        end
      end

      def remove_category(id:, recursive: false)
        query = { 
          clientId: self.client_id,
          catId: id,
          cascade: recursive
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def remove_category_locale(id:, locale:)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_category_pretty_id(id:, locale:)
        body = { 
          clientId: self.client_id,
          categoryId: id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def set_parent_category(id:, parent_id:)
        query = { 
          clientId: self.client_id,
          categoryId: id,
          categoryParentId: parent_id
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def update_category(id:, data: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          categoryId: id,
          update: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_category_locale(id:, locale: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          property: locale.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_category_pretty_id(id:, pretty_id: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          categoryId: id,
          prettyId: pretty_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end
    end
  end
end
