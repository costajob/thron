require_relative 'session'

module Thron
  module Gateway
    class Repository < Session

      base_uri "#{Config::thron::protocol}://#{Config::thron::client_id}-view.thron.com/api"

      PACKAGE = Package.new(:xpackager, :resources, self.service_name)

      paginate :get_ftp_file_list, :get_uploaded_file_list

      def self.routes
        @routes ||= {
          add_files: Route::factory(name: 'addFilesToPlatform', package: PACKAGE),
          add_s3_resource: Route::factory(name: 'addS3ResourceToPlatform', package: PACKAGE),
          add_web_resource: Route::factory(name: 'addWebResourceToPlatform', package: PACKAGE),
          delete_ftp_file: Route::factory(name: 'deleteFtpFile', package: PACKAGE),
          delete_uploaded_file: Route::factory(name: 'deleteUploadedFile', package: PACKAGE),
          get_ftp_file_list: Route::factory(name: 'getFtpFileList', package: PACKAGE),
          get_quota_usage: Route::factory(name: 'getQuotaUsage', package: PACKAGE, verb: Route::Verbs::GET),
          get_s3_credentials: Route::factory(name: 'getS3UploadCredentials', package: PACKAGE, verb: Route::Verbs::GET),
          get_uploaded_file_list: Route::factory(name: 'getUploadedFileList', package: PACKAGE)
        }
      end

      def add_files(files:)
        body = { 
          clientId: client_id,
          files: { files: files }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end

      def add_s3_resource(resource:, remove_resource: false)
        body = { 
          clientId: client_id,
          resource: resource,
          remove_resource_if_possible: remove_resource
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end

      def add_web_resource(resource:)
        body = { 
          clientId: client_id,
          webResource: resource
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end

      %i[delete_ftp_file delete_uploaded_file].each do |message|
        define_method(message) do |args|
          file = args.fetch(:file)
          body = { 
            clientId: client_id,
            file: file
          }
          route(to: __callee__, body: body, token_id: token_id)
        end
      end

      %i[get_ftp_file_list get_uploaded_file_list].each do |message|
        define_method(message) do |args|
          criteria = args.fetch(:criteria) { {} }
          order_by = args[:order_by]
          offset = args.fetch(:offset) { 0 }
          limit = args.fetch(:limit) { 0 }
          body = { 
            clientId: client_id,
            criteria: criteria,
            orderByField: order_by,
            offset: offset.to_i,
            numberOfResult: limit.to_i
          }
          route(to: __callee__, body: body, token_id: token_id) do |response|
            response.body = response.body.fetch('uploadedFiles') { [] }.map do |file|
              Entity::Base::new(file)
            end
          end
        end
      end

      def get_quota_usage
        query = { 
          clientId: client_id,
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end

      def get_s3_credentials
        query = { 
          clientId: client_id,
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('credentials') { {} })
        end
      end
    end
  end
end
