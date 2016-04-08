require 'thron/gateway/session'

module Thron
  module Gateway
    class PublishingProcess < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def self.routes
        @routes ||= {
          change_channel_status: Route::factory(name: 'changeChannelStatus', package: PACKAGE), 
          create_content_for_channel: Route::factory(name: 'createContentForChannel', package: PACKAGE),
          get_content_types: Route::factory(name: 'getContentTypes', package: PACKAGE),
          new_content: Route::factory(name: 'newContent', package: PACKAGE),
          new_live_event_content: Route::factory(name: 'newLiveEventContent', package: PACKAGE),
          new_pagelet_content: Route::factory(name: 'newPageletContent', package: PACKAGE),
          new_playlist_content: Route::factory(name: 'newPlayListContent', package: PACKAGE),
          publish_channel: Route::factory(name: 'publishChannel', package: PACKAGE),
          remove_channel: Route::factory(name: 'removeChannel', package: PACKAGE),
          replace_thumbnail: Route::factory(name: 'replaceThumbnailInPublishedContent', package: PACKAGE),
          unpublish_content: Route::factory(name: 'unpublishContent', package: PACKAGE),
          update_pagelet_content: Route::factory(name: 'updatePageletContent', package: PACKAGE),
          update_publishing_properties: Route::factory(name: 'updatePublishingProperties', package: PACKAGE)
        }
      end

      def change_channel_status(options = {})
        media_content_id = options[:media_content_id]
        content_id = options[:content_id]
        channel = options[:channel]
        active = options.fetch(:active) { false }
        body = { 
          clientId: client_id,
          mediaContentId: media_content_id,
          xcontentId: content_id,
          channel: channel,
          active: active
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.extra(attribute: 'actionsInError')
          response.body = Entity::Base::factory(response.body.fetch('content') { {} })
        end
      end

      def get_content_types(options = {})
        file_names = options[:file_names]
        body = { 
          clientId: client_id,
          files: { fileNames: file_names }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('fileContentTypes') { [] })
        end
      end

      def unpublish_content(options = {})
        media_content_id = options[:media_content_id]
        content_id = options[:content_id]
        force = options.fetch(:force) { false }
        remove_source_files = options.fetch(:remove_source_files) { false }
        body = { 
          clientId: client_id,
          mediaContentId: media_content_id,
          xcontentId: content_id,
          force: force,
          removeSourceFiles: remove_source_files
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.extra(attribute: 'actionsInError')
          response.body = Entity::Base::factory(response.body.fetch('content') { {} })
        end
      end

      def update_pagelet_content(options = {})
        media_content_id = options[:media_content_id]
        content_id = options[:content_id]
        body = options[:body]
        mime_type = options[:mime_type]
        body = { 
          clientId: client_id,
          mediaContentId: media_content_id,
          xcontentId: content_id,
          body: body,
          mimeType: mime_type
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.extra(attribute: 'actionsInError')
          response.body = Entity::Base::factory(response.body.fetch('content') { {} })
        end
      end

      def update_publishing_properties(options = {})
        media_content_id = options[:media_content_id]
        content_id = options[:content_id]
        properties = options[:properties]
        body = { 
          clientId: client_id,
          mediaContentId: media_content_id,
          xcontentId: content_id,
          properties: properties
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.extra(attribute: 'actionsInError')
          response.body = Entity::Base::factory(response.body.fetch('content') { {} })
        end
      end

      %i[publish remove].each do |action|
        define_method "#{action}_channel" do |options|
          media_content_id = options.fetch(:media_content_id)
          content_id = options.fetch(:content_id)
          channel = options.fetch(:channel)
          body = { 
            clientId: client_id,
            mediaContentId: media_content_id,
            xcontentId: content_id,
            channel: channel
          }
          route(to: __callee__, body: body, token_id: token_id) do |response|
            response.extra(attribute: 'actionsInError')
            response.body = Entity::Base::factory(response.body.fetch('content') { {} })
          end
        end
      end

      %i[create_content_for_channel new_content new_live_event_content new_pagelet_content new_playlist_content replace_thumbnail].each do |message|
        define_method(message) do |options|
          data = options[:data]
          body = { 
            clientId: client_id,
            param: data
          }
          route(to: message, body: body, token_id: token_id) do |response|
            response.extra(attribute: 'actionsInError')
            response.body = Entity::Base::factory(response.body.fetch('content') { {} })
          end
        end
      end
    end
  end
end
