require 'thron/gateway/session'

module Thron
  module Gateway
    class Comment < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      paginate :list_comments

      def self.routes
        @routes ||= {
          comment_detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET),
          list_comments: Route::factory(name: 'getComments', package: PACKAGE, verb: Route::Verbs::GET),
          insert_comment: Route::factory(name: 'insertComment', package: PACKAGE),
          report_comment_abuse: Route::factory(name: 'reportAbuse', package: PACKAGE)
        }
      end

      def comment_detail(options = {})
        comment_id = options[:comment_id]
        query = { 
          clientId: client_id,
          commentId: comment_id
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('comment') { {} })
        end
      end

      def list_comments(options = {})
        criteria = options.fetch(:criteria) { {} }
        locale = options[:locale]
        order_by = options[:order_by]
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        order_by = order_by ? { orderBy: order_by } : {}
        query = { 
          clientId: client_id,
          locale: locale,
          offset: offset,
          numberOfResults: limit
        }.merge(criteria).merge(order_by)
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('comments') { [] })
        end
      end

      def insert_comment(options = {})
        content_id = options[:content_id]
        data = options[:data]
        category_id = options[:category_id]
        body = { 
          clientId: client_id,
          contentId: content_id,
          comment: data,
          categoryIdForAcl: category_id
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('comment') { {} })
        end
      end

      def report_comment_abuse(options = {})
        comment_id = options[:comment_id]
        user_id = options[:user_id]
        query = { 
          clientId: client_id,
          commentId: comment_id,
          userId: user_id
        }
        route(to: __callee__, query: query, token_id: token_id)
      end
    end
  end
end
