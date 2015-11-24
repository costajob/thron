require 'thron/paginator'

module Thron
  module Pageable
    module ClassMethods
      def paginate(*apis)
        (@paginated_apis = apis).each do |api|
          define_method("#{api}_paginator") do |*args|
            options = args.empty? ? {} : args.last
            limit = options.delete(:limit) { Paginator::MAX_LIMIT }
            body = ->(limit, offset) { send(api, options.merge!({ offset: offset, limit: limit })) }
            Paginator::new(body: body, limit: limit)
          end
        end
      end

      def paginator_methods
        Array(@paginated_apis).map { |api| :"#{api}_paginator" }
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end
