require 'thron/gateway/session'

module Thron
  module Gateway
    class Dashboard < Session

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def self.routes
        @routes ||= {
          change_contents_owner: Route::factory(name: 'changeContentsOwner', package: PACKAGE),
          download_source_file: Route::factory(name: 'downloadSourceFile', package: PACKAGE, verb: Route::Verbs::GET),
          migrate_user_stuff: Route::factory(name: 'migrateUserStuff', package: PACKAGE),
          propagate_acl_to_sub_categories: Route::factory(name: 'propagateAclToSubCategories', package: PACKAGE),
          replace_source_files: Route::factory(name: 'replaceSourceFiles', package: PACKAGE),
          reset_content_user_preferences: Route::factory(name: 'resetUserPreferences', package: PACKAGE),
          trash_contents: Route::factory(name: 'trashContent', package: PACKAGE),
          untrash_contents: Route::factory(name: 'untrashContent', package: PACKAGE)
        }
      end

      def change_contents_owner(options = {})
        contents = options[:contents]
        body = { 
          clientId: client_id,
          contents: contents
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def download_source_file(options = {})
        content_id = options[:content_id]
        save_as = options[:save_as]
        query = { 
          clientId: client_id,
          tokenId: token_id,
          xcontentId: content_id,
          saveAs: save_as
        }
        route(to: __callee__, query: query, token_id: token_id)
      end

      def migrate_user_stuff(options = {})
        user_id1 = options[:user_id1]
        user_id2 = options[:user_id2]
        remove_user_id1 = options.fetch(:remove_user_id1) { false }
        body = { 
          clientId: client_id,
          userId1: user_id1,
          userId2: user_id2,
          removeUserId1: remove_user_id1
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def propagate_acl_to_sub_categories(options = {})
        category_id = options[:category_id]
        acls = options[:acls]
        force = options.fetch(:force) { false }
        body = { 
          clientId: client_id,
          categoryId: category_id,
          acls: acls,
          force: force
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def replace_source_files(options = {})
        media_content_id = options[:media_content_id]
        content_id = options[:content_id]
        file_ids = options[:file_ids]
        remove_original_files = options.fetch(:remove_original_files) { false }
        body = { 
          clientId: client_id,
          mediaContentId: media_content_id,
          xcontentId: content_id,
          sourceFiles: { repositoryFileIds: file_ids },
          removeOriginalFiles: remove_original_files
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def reset_content_user_preferences(options = {})
        content_id = options[:content_id]
        body = { 
          clientId: client_id,
          xcontentId: content_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def trash_contents(options = {})
        contents = options[:contents]
        body = { 
          clientId: client_id,
          contentList: { contentsToTrash: contents.map(&:payload) }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.extra(attribute: 'contentsInIssue')
        end
      end
      
      def untrash_contents(options = {})
        new_user_id = options[:new_user_id]
        content_ids = options[:content_ids]
        body = { 
          clientId: client_id,
          contentList: { 
            newUserId: new_user_id,
            xcontentIds: content_ids
          }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.extra(attribute: 'contentsInIssue')
        end
      end
    end
  end
end
