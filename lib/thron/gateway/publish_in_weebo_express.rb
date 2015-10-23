require_relative 'session'

module Thron
  module Gateway
    class PublishInWeeboExpress < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      %i[audio content_in_channels document image live_event pagelet playlist program video].each do |message|
        define_method(message) do |args|
          data = args.fetch(:data) { Entity::Base::new }
          body = { 
            clientId: self.client_id,
            param: data.to_payload
          }
          route(to: message, body: body, token_id: token_id) do |response|
            response.body = Entity::Base::new(response.body.fetch('content') { {} })
          end
        end
      end

      def self.routes
        @routes ||= {
          audio: Route::factory(name: 'publishAudio', package: PACKAGE),
          content_in_channels: Route::factory(name: 'publishContentInChannels', package: PACKAGE),
          document: Route::factory(name: 'publishDocument', package: PACKAGE),
          image: Route::factory(name: 'publishImage', package: PACKAGE),
          live_event: Route::factory(name: 'publishLiveEvent', package: PACKAGE),
          pagelet: Route::factory(name: 'publishPagelet', package: PACKAGE),
          playlist: Route::factory(name: 'publishPlayList', package: PACKAGE),
          program: Route::factory(name: 'publishProgram', package: PACKAGE),
          video: Route::factory(name: 'publishVideo', package: PACKAGE),
          upload: Route::factory(name: 'uploadAndPublish', package: PACKAGE)
        }
      end
    end
  end
end
