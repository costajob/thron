require 'thron/gateway/session'

module Thron
  module Gateway
    class Delivery < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      paginate :content_cuepoints, :downloadable_contents

      def self.routes
        @routes ||= {
          content_metadata: Route::factory(name: 'getContentDetail', package: PACKAGE, verb: Route::Verbs::GET),
          content_cuepoints: Route::factory(name: 'getCuePoints', package: PACKAGE, verb: Route::Verbs::GET),
          downloadable_contents: Route::factory(name: 'getDownloadableContents', package: PACKAGE, verb: Route::Verbs::GET),
          playlist_contents: Route::factory(name: 'getPlaylistContents', package: PACKAGE, verb: Route::Verbs::GET),
          recommended_contents: Route::factory(name: 'getRecommendedContents', package: PACKAGE, verb: Route::Verbs::GET),
          similar_contents: Route::factory(name: 'getSimilarContents', package: PACKAGE, verb: Route::Verbs::GET),
          content_subtitles: Route::factory(name: 'getSubTitles', package: PACKAGE, verb: Route::Verbs::GET),
          content_thumbnail: Route::lazy_factory(name: 'getThumbnail', package: PACKAGE, verb: Route::Verbs::GET)
        }
      end

      def content_metadata(content_id:, locale: nil, linked_channel_type: nil, linked_user_agent: nil, div_area: nil, pkey: nil, lcid: nil)
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          locale: locale,
          linkedChannelType: linked_channel_type,
          linkedUserAgent: linked_user_agent,
          divArea: div_area,
          pkey: pkey,
          lcid: lcid
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          content = response.body.fetch('content') { {} }
          response.body = Entity::Base::factory(response.body.merge!(content))
        end
      end

      def content_cuepoints(content_id: nil, publisher_id: nil, cuepoint_types: nil, actions: nil, start_time: nil, end_time: nil, draft: nil, username: nil, cuepoint_group: nil, pkey: nil, lcid: nil, offset: 0, limit: 0)
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          xpublisherId: publisher_id,
          cuePointTypes: cuepoint_types,
          actions: actions,
          startTime: start_time,
          endTime: end_time,
          draft: draft,
          username: username,
          cuePointGroup: cuepoint_group,
          pkey: pkey,
          lcid: lcid,
          offset: offset,
          numberOfResult: limit
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('cuePoints') { [] })
        end
      end

      def downloadable_contents(content_id: nil, publisher_id: nil, locale: nil, admin: nil, div_area: nil, pkey: nil, lcid: nil, offset: 0, limit: 0)
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          xpublisherId: publisher_id,
          locale: locale,
          admin: admin,
          divArea: div_area,
          pkey: pkey,
          lcid: lcid,
          offset: offset,
          numberOfResult: limit
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('contents') { [] })
        end
      end
    end
  end
end
