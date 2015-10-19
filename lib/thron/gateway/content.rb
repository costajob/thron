require_relative 'session'

module Thron
  module Gateway
    class Content < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      %w[create update].each do |action|
        define_method("#{action}_locale") do |args|
          id          = args.fetch(:id)
          locale      = args.fetch(:locale) { Entity::Base::new }
          category_id = args.fetch(:category_id) { nil }
          body = { 
            client: {
              clientId: self.client_id
            },
            contentId: id,
            detail: locale.to_payload,
            categoryIdForAcl: category_id
          }
          route(to: __callee__, body: body, token_id: token_id)
        end

        define_method("#{action}_pretty_id") do |args|
          id          = args.fetch(:id)
          pretty_id   = args.fetch(:pretty_id) { Entity::Base::new }
          category_id = args.fetch(:category_id) { nil }
          body = { 
            clientId: self.client_id,
            contentId: id,
            prettyId: pretty_id.to_payload,
            categoryIdForAcl: category_id
          }
          route(to: __callee__, body: body, token_id: token_id)
        end

        define_method("#{action}_player") do |args|
          id   = args.fetch(:id)
          data = args.fetch(:data) { Entity::Base::new }
          body = { 
            clientId: self.client_id,
            contentId: id,
            embedCode: data.to_payload
          }
          route(to: __callee__, body: body, token_id: token_id)
        end
      end

      def link_content(id:, data: Entity::Base::new, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          linkedContent: data.to_payload,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def link_contents(id:, contents: [], category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          linkedContents: {
            contents: contents.map(&:to_payload)
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def detail(id:, options: Entity::Base::new, locale: nil, access_key: nil)
        query = { 
          clientId: self.client_id,
          contentId: id,
          locale: locale,
          pkey: access_key
        }.merge(options.to_payload)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          content = response.body.delete('content') { {} }
          response.body = Entity::Base::new(response.body.merge(content))
        end
      end

      def find(criteria: Entity::Base::new, options: Entity::Base::new, locale: nil, div_area: nil, order_by: nil, offset: 0, limit: 0)
        body = { 
          client: {
            clientId: self.client_id
          },
          criteria: criteria.to_payload,
          contentFieldOption: options.to_payload,
          locale: locale,
          divArea: div_area,
          orderBy: order_by,
          offset: offset.to_i,
          numberOfresults: limit.to_i
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('contents') { [] }.map do |content|
            detail = content.delete('content') { {} }
            Entity::Base::new(content.merge!(detail))
          end
        end
      end
      
      def move(id:, from: 0, to: 0, link_type: nil)
        body = { 
          clientId: self.client_id,
          xcontentId: id,
          oldPosition: from.to_i,
          newPosition: to.to_i,
          linkType: link_type
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_locale(id:, locale:)
        query = { 
          clientId: self.client_id,
          contentId: id,
          locale: locale
        }
        route(to: __callee__, query: query, token_id: token_id)
      end

      def remove_pretty_id(id:, locale:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          locale: locale,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def unlink_contents(id:, criteria: Entity::Base::new, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          criteria: criteria.to_payload,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_player(id:, player_id:)
        body = { 
          clientId: self.client_id,
          contentId: id,
          embedCodeId: player_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_solutions(id:, solutions: [], category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          contentValues: {
            availableInSolutions: solutions
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update(id:, data: Entity::Base::new, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          contentValues: data.to_payload,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_players(id:, players: [], category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: id,
          embedCodes: {
            embedCodes: players.map(&:to_payload)
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_user(username:, id:, data: Entity::Base::new, category_id: nil)
        body = { 
          clientId: self.client_id,
          username: username,
          contentId: id,
          contentParams: data.to_payload,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def self.routes
        @routes ||= {
          create_locale: Route::factory(name: 'addContent4Locale', package: PACKAGE),
          create_pretty_id: Route::factory(name: 'addContentPrettyId', package: PACKAGE),
          link_content: Route::factory(name: 'addLinkedContent', package: PACKAGE),
          link_contents: Route::factory(name: 'addLinkedContents', package: PACKAGE),
          create_player: Route::factory(name: 'addPlayerEmbedCode', package: PACKAGE),
          detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET),
          find: Route::factory(name: 'findByProperties', package: PACKAGE),
          move: Route::factory(name: 'moveLinkedContent', package: PACKAGE),
          remove_locale: Route::factory(name: 'removeContent4Locale', package: PACKAGE),
          remove_pretty_id: Route::factory(name: 'removeContentPrettyId', package: PACKAGE),
          unlink_contents: Route::factory(name: 'removeLinkedContents', package: PACKAGE),
          remove_player: Route::factory(name: 'removePlayerEmbedCode', package: PACKAGE),
          update_solutions: Route::factory(name: 'updateAvailableSolutions', package: PACKAGE),
          update: Route::factory(name: 'updateContent', package: PACKAGE),
          update_locale: Route::factory(name: 'updateContent4Locale', package: PACKAGE),
          update_pretty_id: Route::factory(name: 'updateContentPrettyId', package: PACKAGE),
          update_player: Route::factory(name: 'updatePlayerEmbedCode', package: PACKAGE),
          update_players: Route::factory(name: 'updatePlayerEmbedCodes', package: PACKAGE),
          update_user: Route::factory(name: 'updateUserSpecificValues', package: PACKAGE)
        }
      end
    end
  end
end
