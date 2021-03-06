require 'thron/gateway/session'

module Thron
  module Gateway
    class Metadata < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def self.routes
        @routes ||= {
          insert_metadata: Route::factory(name: 'insertMetadata', package: PACKAGE),
          remove_all_metadata: Route::factory(name: 'removeAllMetadata', package: PACKAGE),
          remove_metadata: Route::factory(name: 'removeMetadata', package: PACKAGE),
          update_metadata: Route::factory(name: 'updateMetadata', package: PACKAGE),
          update_single_metadata: Route::factory(name: 'updateSingleMetadata', package: PACKAGE)
        }
      end

      def insert_metadata(options = {})
        content_id = options[:content_id]
        data = options[:data]
        category_id = options[:category_id]
        body = { 
          client: { clientId: client_id },
          contentId: content_id,
          metadata: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def remove_all_metadata(options = {})
        content_id = options[:content_id]
        body = { 
          clientId: client_id,
          contentId: content_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def update_metadata(options = {})
        content_id = options[:content_id]
        data_list = options[:data_list]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          metadata: { metadata: data_list },
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end
      
      %w[remove update_single].each do |action|
        define_method("#{action}_metadata") do |options|
          content_id = options[:content_id]
          data = options[:data]
          body = { 
            clientId: client_id,
            contentId: content_id,
            metadata: data
          }
          route(to: __callee__, body: body, token_id: token_id)
        end
      end
    end
  end
end
