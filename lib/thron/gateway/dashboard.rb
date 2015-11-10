require_relative 'session'

module Thron
  module Gateway
    class Dashboard < Session

      paginate :get_usage_quota_by_users

      PACKAGE = Package.new(:xadmin, :resources, self.service_name)

      def self.routes
        @routes ||= {
          change_contents_owner: Route::factory(name: 'changeContentsOwner', package: PACKAGE),
          download_source_file: Route::factory(name: 'downloadSourceFile', package: PACKAGE, verb: Route::Verbs::GET),
          get_usage_quota_by_users: Route::factory(name: 'getQuotaUsageByUsers', package: PACKAGE),
          migrate_user_stuff: Route::factory(name: 'migrateUserStuff', package: PACKAGE),
          propagate_acl_to_sub_categories: Route::factory(name: 'propagateAclToSubCategories', package: PACKAGE),
          replace_source_files: Route::factory(name: 'replaceSourceFiles', package: PACKAGE),
          reset_content_user_preferences: Route::factory(name: 'resetUserPreferences', package: PACKAGE),
          trash_contents: Route::factory(name: 'trashContent', package: PACKAGE),
          untrash_contents: Route::factory(name: 'untrashContent', package: PACKAGE)
        }
      end

      def change_contents_owner(contents: Entity::Base::new)
        body = { 
          clientId: self.client_id,
          contents: contents.to_payload
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def download_source_file(content_id:, save_as:)
        query = { 
          clientId: self.client_id,
          tokenId: token_id,
          xcontentId: content_id,
          saveAs: save_as
        }
        route(to: __callee__, query: query, token_id: token_id)
      end

      def get_usage_quota_by_users(user_ids:, offset: 0, limit: 0)
        body = { 
          clientId: self.client_id,
          criteria: { userIds: user_ids },
          offset: offset,
          numberOfResult: limit
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body.fetch('users') { {} })
        end
      end

      def migrate_user_stuff(user_id1:, user_id2:, remove_user_id1: false)
        body = { 
          clientId: self.client_id,
          userId1: user_id1,
          userId2: user_id2,
          removeUserId1: remove_user_id1
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def propagate_acl_to_sub_categories(category_id:, acls: Entity::Base::new, force: false)
        body = { 
          clientId: self.client_id,
          categoryId: category_id,
          acls: acls.to_payload,
          force: force
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def replace_source_files(media_content_id:, content_id:, file_ids:, remove_original_files: false)
        body = { 
          clientId: self.client_id,
          mediaContentId: media_content_id,
          xcontentId: content_id,
          sourceFiles: { repositoryFileIds: file_ids },
          removeOriginalFiles: remove_original_files
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def reset_content_user_preferences(content_id:)
        body = { 
          clientId: self.client_id,
          xcontentId: content_id
        }
        route(to: __callee__, body: body, token_id: token_id)
      end

      def trash_contents(contents:)
        body = { 
          clientId: self.client_id,
          contentList: { contentsToTrash: contents.map(&:payload) }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end
      
      def untrash_contents(new_user_id:, content_ids:)
        body = { 
          clientId: self.client_id,
          contentList: { 
            newUserId: new_user_id,
            xcontentIds: content_ids
          }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::new(response.body)
        end
      end
    end
  end
end