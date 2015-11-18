require_relative 'session'

module Thron
  module Gateway
    class ContentCategory < Session

      PACKAGE = Package.new(:xcontents, :resources, self.service_name)

      def self.routes
        @routes ||= {
          link_category_to_content: Route::factory(name: 'linkCategoryToContent', package: PACKAGE),
          remove_category_from_content: Route::factory(name: 'removeCategoryToContent', package: PACKAGE)
        }
      end

      self.routes.keys.each do |message|
        define_method(message) do |args|
          category_id = args.fetch(:category_id)
          content_id = args.fetch(:content_id)
          apply_acl = args.fetch(:apply_acl) { false }
          query = { 
            clientId: client_id,
            categoryId: category_id,
            contentId: content_id,
            applyAcl: apply_acl
          }
          route(to: __callee__, query: query, token_id: token_id)
        end
      end
    end
  end
end
