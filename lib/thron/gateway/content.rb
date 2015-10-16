require_relative 'session'

module Thron
  module Gateway
    class Content < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def create_locale(id:, category_id: nil, locale: Entity::Base::new)
        body = { 
          client: {
            clientId: self.client_id
          },
          contentId: id,
          categoryIdForAcl: category_id,
          detail: locale.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def create_pretty_id(id:, category_id: nil, pretty_id: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          contentId: id,
          categoryIdForAcl: category_id,
          prettyId: pretty_id.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def link_content(id:, category_id: nil, content: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          contentId: id,
          categoryIdForAcl: category_id,
          linkedContent: content.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def link_contents(id:, category_id: nil, contents: [])
        body = { 
          clientId: self.client_id,
          contentId: id,
          categoryIdForAcl: category_id,
          linkedContents: {
            contents: contents.map(&:to_payload)
          }
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_player(id:, embed_code: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          contentId: id,
          embedCode: embed_code.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def self.routes
        @routes ||= {
          create_locale: Route::factory(name: 'addContent4Locale', package: PACKAGE),
          create_pretty_id: Route::factory(name: 'addContentPrettyId', package: PACKAGE),
          link_content: Route::factory(name: 'addLinkedContent', package: PACKAGE),
          link_contents: Route::factory(name: 'addLinkedContents', package: PACKAGE),
          add_player: Route::factory(name: 'addPlayerEmbedCode', package: PACKAGE)
        }
      end
    end
  end
end
