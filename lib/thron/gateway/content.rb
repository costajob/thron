require 'thron/gateway/session'

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
        define_method("#{action}_content_for_locale") do |options|
          content_id = options[:content_id]
          locale = options[:locale]
          category_id = options[:category_id]
          body = { 
            client: {
              clientId: client_id
            },
            contentId: content_id,
            detail: locale,
            categoryIdForAcl: category_id
          }
          route(to: __callee__, body: body, token_id: token_id)
        end

        define_method("#{action}_content_pretty_id") do |options|
          content_id = options[:content_id]
          pretty_id = options[:pretty_id]
          category_id = options[:category_id]
          body = { 
            clientId: client_id,
            contentId: content_id,
            prettyId: pretty_id,
            categoryIdForAcl: category_id
          }
          route(to: __callee__, body: body, token_id: token_id)
        end

        define_method("#{action}_player_embed_code") do |options|
          content_id = options[:content_id]
          data = options[:data]
          body = { 
            clientId: client_id,
            contentId: content_id,
            embedCode: data
          }
          route(to: __callee__, body: body, token_id: token_id)
        end
      end

      def add_linked_content(options = {})
        content_id = options[:content_id]
        data = options[:data]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          linkedContent: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def add_linked_contents(options = {})
        content_id = options[:content_id]
        contents = options[:contents]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          linkedContents: {
            contents: contents
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def content_detail(options = {})
        content_id = options[:content_id]
        extra = options.fetch(:extra) { {} }
        locale = options[:locale]
        access_key = options[:access_key]
        query = { 
          clientId: client_id,
          contentId: content_id,
          locale: locale,
          pkey: access_key
        }.merge(extra)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end

      def find_contents(options = {})
        criteria = options.fetch(:criteria) { {} }
        field_option = options.fetch(:field_option) { {} }
        locale = options[:locale]
        div_area = options[:div_area]
        order_by = options[:order_by]
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        body = { 
          client: {
            clientId: client_id
          },
          criteria: criteria,
          contentFieldOption: field_option,
          locale: locale,
          divArea: div_area,
          orderBy: order_by,
          offset: offset.to_i,
          numberOfresults: limit.to_i
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('contents') { [] })
        end
      end
      
      def move_linked_content(options = {})
        content_id = options[:content_id]
        from = options[:from].to_i
        to = options[:to].to_i
        link_type = options[:link_type]
        body = { 
          clientId: client_id,
          xcontentId: content_id,
          oldPosition: from.to_i,
          newPosition: to.to_i,
          linkType: link_type
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_content_for_locale(options = {})
        content_id = options[:content_id]
        locale = options[:locale]
        query = { 
          clientId: client_id,
          contentId: content_id,
          locale: locale
        }
        route(to: __callee__, query: query, token_id: token_id)
      end

      def remove_content_pretty_id(options = {})
        content_id = options[:content_id]
        locale = options[:locale]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          locale: locale,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_linked_contents(options = {})
        content_id = options[:content_id]
        criteria = options.fetch(:criteria) { {} }
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          criteria: criteria,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_player_embed_code(options = {})
        content_id = options[:content_id]
        player_id = options[:player_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          embedCodeId: player_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_available_solutions(options = {})
        content_id = options[:content_id]
        solutions = options[:solutions].to_a
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          contentValues: {
            availableInSolutions: solutions
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_content(options = {})
        content_id = options[:content_id]
        data = options[:data]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          contentValues: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_player_embed_codes(options = {})
        content_id = options[:content_id]
        players = options[:players]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          embedCodes: {
            embedCodes: players
          },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_user_specific_values(options = {})
        username = options[:username]
        content_id = options[:content_id]
        data = options[:data]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
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
