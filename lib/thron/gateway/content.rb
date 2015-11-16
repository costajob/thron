require_relative 'session'

module Thron
  module Gateway
    class Content < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      paginate :find_contents

      def self.routes
        @routes ||= {
          add_content_for_locale: Route::factory(name: 'addContent4Locale', package: PACKAGE),
          add_content_pretty_id: Route::factory(name: 'addContentPrettyId', package: PACKAGE),
          add_player_embed_code: Route::factory(name: 'addPlayerEmbedCode', package: PACKAGE),
          add_linked_content: Route::factory(name: 'addLinkedContent', package: PACKAGE),
          add_linked_contents: Route::factory(name: 'addLinkedContents', package: PACKAGE),
          content_detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET),
          find_contents: Route::factory(name: 'findByProperties', package: PACKAGE),
          move_linked_content: Route::factory(name: 'moveLinkedContent', package: PACKAGE),
          remove_content_for_locale: Route::factory(name: 'removeContent4Locale', package: PACKAGE),
          remove_content_pretty_id: Route::factory(name: 'removeContentPrettyId', package: PACKAGE),
          remove_linked_contents: Route::factory(name: 'removeLinkedContents', package: PACKAGE),
          remove_player_embed_code: Route::factory(name: 'removePlayerEmbedCode', package: PACKAGE),
          update_available_solutions: Route::factory(name: 'updateAvailableSolutions', package: PACKAGE),
          update_content: Route::factory(name: 'updateContent', package: PACKAGE),
          update_content_for_locale: Route::factory(name: 'updateContent4Locale', package: PACKAGE),
          update_content_pretty_id: Route::factory(name: 'updateContentPrettyId', package: PACKAGE),
          update_player_embed_code: Route::factory(name: 'updatePlayerEmbedCode', package: PACKAGE),
          update_player_embed_codes: Route::factory(name: 'updatePlayerEmbedCodes', package: PACKAGE),
          update_user_specific_values: Route::factory(name: 'updateUserSpecificValues', package: PACKAGE)
        }
      end

      %w[add update].each do |action|
        define_method("#{action}_content_for_locale") do |args|
          content_id = args.fetch(:content_id)
          locale = args.fetch(:locale)
          category_id = args.fetch(:category_id) { nil }
          body = { 
            client: {
              clientId: self.client_id
            },
            contentId: content_id,
            detail: locale,
            categoryIdForAcl: category_id
          }
          route(to: __callee__, body: body, token_id: token_id)
        end

        define_method("#{action}_content_pretty_id") do |args|
          content_id = args.fetch(:content_id)
          pretty_id = args.fetch(:pretty_id)
          category_id = args.fetch(:category_id) { nil }
          body = { 
            clientId: self.client_id,
            contentId: content_id,
            prettyId: pretty_id,
            categoryIdForAcl: category_id
          }
          route(to: __callee__, body: body, token_id: token_id)
        end

        define_method("#{action}_player_embed_code") do |args|
          content_id = args.fetch(:content_id)
          data = args.fetch(:data)
          body = { 
            clientId: self.client_id,
            contentId: content_id,
            embedCode: data
          }
          route(to: __callee__, body: body, token_id: token_id)
        end
      end

      def add_linked_content(content_id:, data:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          linkedContent: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_linked_contents(content_id:, contents:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          linkedContents: {
            contents: contents
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def content_detail(content_id:, options:, locale: nil, access_key: nil)
        query = { 
          clientId: self.client_id,
          contentId: content_id,
          locale: locale,
          pkey: access_key
        }.merge(options)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          content = response.body.delete('content') { {} }
          response.body = Entity::Base::new(response.body.merge(content))
        end
      end

      def find_contents(criteria:, options:, locale: nil, div_area: nil, order_by: nil, offset: 0, limit: 0)
        body = { 
          client: {
            clientId: self.client_id
          },
          criteria: criteria,
          contentFieldOption: options,
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
      
      def move_linked_content(content_id:, from: 0, to: 0, link_type: nil)
        body = { 
          clientId: self.client_id,
          xcontentId: content_id,
          oldPosition: from.to_i,
          newPosition: to.to_i,
          linkType: link_type
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_content_for_locale(content_id:, locale:)
        query = { 
          clientId: self.client_id,
          contentId: content_id,
          locale: locale
        }
        route(to: __callee__, query: query, token_id: token_id)
      end

      def remove_content_pretty_id(content_id:, locale:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          locale: locale,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_linked_contents(content_id:, criteria:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          criteria: criteria,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_player_embed_code(content_id:, player_id:)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          embedCodeId: player_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_available_solutions(content_id:, solutions: [], category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          contentValues: {
            availableInSolutions: solutions
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_content(content_id:, data:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          contentValues: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_player_embed_codes(content_id:, players:, category_id: nil)
        body = { 
          clientId: self.client_id,
          contentId: content_id,
          embedCodes: {
            embedCodes: players
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_user_specific_values(username:, content_id:, data:, category_id: nil)
        body = { 
          clientId: self.client_id,
          username: username,
          contentId: content_id,
          contentParams: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end
    end
  end
end
