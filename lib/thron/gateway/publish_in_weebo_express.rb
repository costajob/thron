require 'thron/gateway/session'

module Thron
  module Gateway
    class PublishInWeeboExpress < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def self.routes
        @routes ||= {
          publish_audio: Route::factory(name: 'publishAudio', package: PACKAGE),
          publish_content_in_channels: Route::factory(name: 'publishContentInChannels', package: PACKAGE),
          publish_document: Route::factory(name: 'publishDocument', package: PACKAGE),
          publish_image: Route::factory(name: 'publishImage', package: PACKAGE),
          publish_live_event: Route::factory(name: 'publishLiveEvent', package: PACKAGE),
          publish_pagelet: Route::factory(name: 'publishPagelet', package: PACKAGE),
          publish_playlist: Route::factory(name: 'publishPlayList', package: PACKAGE),
          publish_program: Route::factory(name: 'publishProgram', package: PACKAGE),
          publish_video: Route::factory(name: 'publishVideo', package: PACKAGE),
          upload_and_publish: Route::factory(name: 'uploadAndPublish', package: PACKAGE)
        }
      end

      self.routes.keys.each do |message|
        define_method(message) do |args|
          data = args.fetch(:data)
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
