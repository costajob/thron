require 'thron/gateway/session'

module Thron
  module Gateway
    class Delivery < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      paginate :content_cuepoints, :downloadable_contents, :playlist_contents, :recommended_contents

      def self.routes
        @routes ||= {
          content_metadata: Route::factory(name: 'getContentDetail', package: PACKAGE, verb: Route::Verbs::GET),
          content_cuepoints: Route::factory(name: 'getCuePoints', package: PACKAGE, verb: Route::Verbs::GET),
          downloadable_contents: Route::factory(name: 'getDownloadableContents', package: PACKAGE, verb: Route::Verbs::GET),
          playlist_contents: Route::factory(name: 'getPlaylistContents', package: PACKAGE, verb: Route::Verbs::GET),
          recommended_contents: Route::factory(name: 'getRecommendedContents', package: PACKAGE, verb: Route::Verbs::GET),
          content_subtitles: Route::factory(name: 'getSubTitles', package: PACKAGE, verb: Route::Verbs::GET, accept: Route::Types::PLAIN),
          content_thumbnail: Route::lazy_factory(name: 'getThumbnail', package: PACKAGE, verb: Route::Verbs::GET)
        }
      end

      def content_metadata(options = {})
        content_id = options[:content_id]
        criteria = options.fetch(:criteria) { {} }
        query = { 
          clientId: client_id,
          xcontentId: content_id
        }.merge!(criteria)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end

      def content_cuepoints(options = {})
        content_id = options[:content_id]
        criteria = options.fetch(:criteria) { {} }
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          offset: offset,
          numberOfResult: limit
        }.merge!(criteria)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('cuePoints') { [] })
        end
      end

      def downloadable_contents(options = {})
        content_id = options[:content_id]
        criteria = options.fetch(:criteria) { {} }
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          offset: offset,
          numberOfResult: limit
        }.merge!(criteria)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('contents') { [] })
        end
      end

      def playlist_contents(options = {})
        content_id = options[:content_id]
        criteria = options.fetch(:criteria) { {} }
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          offset: offset,
          numberOfResult: limit
        }.merge!(criteria)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('contents') { [] })
        end
      end

      def recommended_contents(options = {})
        content_id = options[:content_id]
        pkey = options[:pkey]
        criteria = options.fetch(:criteria) { { admin: true } }
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          pkey: pkey,
          offset: offset,
          numberOfResult: limit
        }.merge!(criteria)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('contents') { [] })
        end
      end

      def content_subtitles(options = {})
        content_id = options[:content_id]
        locale = options[:locale]
        criteria = options.fetch(:criteria) { {} }
        query = { 
          clientId: client_id,
          xcontentId: content_id,
          locale: locale
        }.merge!(criteria)
        route(to: __callee__, query: query, token_id: token_id)
      end

      def content_thumbnail(options = {})
        content_id = options[:content_id]
        div_area = options[:div_area]
        route(to: __callee__, token_id: token_id, params: [client_id, div_area, content_id]) do |response|
          response.body = Entity::Base::factory(response.body)
        end
      end
    end
  end
end
