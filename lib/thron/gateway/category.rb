require_relative 'session'

module Thron
  module Gateway
    class Category < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def create(parent_id:, locale: Entity::Base::new, is_private: false, solution: nil, data: Entity::Base::new)
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

      def create_system(id:, parent_id:, locale: Entity::Base::new, data: Entity::Base::new)
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

      def create_locale(id:, locale: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          catLocale: locale.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_pretty_id(id:, pretty_id:)
        body = { 
          clientId: self.client_id,
          categoryId: id,
          prettyId: pretty_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def find(args = {})
        preload = args.delete(:preload) { 0 }
        body = ->(limit, offset) { _find(args.merge!({ offset: offset, limit: limit })) }
        Paginator::new(body: body, preload: preload)
      end

      def detail(id:, recursive: false, locale: nil)
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

      def remove(id:, recursive: false)
        query = { 
          clientId: self.client_id,
          catId: id,
          cascade: recursive
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def remove_locale(id:, locale:)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_pretty_id(id:, locale:)
        body = { 
          clientId: self.client_id,
          categoryId: id,
          locale: locale
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def set_parent(id:, parent_id:)
        query = { 
          clientId: self.client_id,
          categoryId: id,
          categoryParentId: parent_id
        }
        route(to: __callee__, query: query, token_id: token_id, dash: false)
      end

      def update(id:, data: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          categoryId: id,
          update: data.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_locale(id:, locale: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          catId: id,
          property: locale.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_pretty_id(id:, pretty_id: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          categoryId: id,
          prettyId: pretty_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
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
        route(to: :find, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('categories') { [] }.map do |category|
            detail = category.delete('category') { {} }
            Entity::Base::new(category.merge!(detail))
          end
        end
      end


      def self.routes
        @routes ||= {
          create: Route::factory(name: 'createCategory', package: PACKAGE),
          create_system: Route::factory(name: 'createSystemCategory', package: PACKAGE),
          create_locale: Route::factory(name: 'addCategory4Locale', package: PACKAGE),
          create_pretty_id: Route::factory(name: 'addCategoryPrettyId', package: PACKAGE),
          find: Route::factory(name: 'findByProperties2', package: PACKAGE),
          detail: Route::factory(name: 'getCategory', package: PACKAGE, verb: Route::Verbs::GET),
          remove: Route::factory(name: 'removeCategory', package: PACKAGE),
          remove_locale: Route::factory(name: 'removeCategory4Locale', package: PACKAGE),
          remove_pretty_id: Route::factory(name: 'removeCategoryPrettyId', package: PACKAGE),
          set_parent: Route::factory(name: 'setParentId', package: PACKAGE),
          update: Route::factory(name: 'updateCategory', package: PACKAGE),
          update_locale: Route::factory(name: 'updateCategory4Locale', package: PACKAGE),
          update_pretty_id: Route::factory(name: 'updateCategoryPrettyId', package: PACKAGE)
        }
      end
    end
  end
end
