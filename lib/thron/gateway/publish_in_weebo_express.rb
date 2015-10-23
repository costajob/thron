require_relative 'session'

module Thron
  module Gateway
    class PublishInWeeboExpress < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)



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
