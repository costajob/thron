require_relative 'paginator'

module Thron
  module Pageable
    module ClassMethods
      def paginate(*apis)
        (@paginated_apis = apis).each do |api|
          define_method("#{api}_paginator") do |*args|
            instance_name = :"@#{api}_paginator"
            instance  = instance_variable_get(instance_name)
            return instance if instance
            options   = args.empty? ? {} : args.last
            preload   = options.delete(:preload) { 0 }
            limit     = options.delete(:limit) { Paginator::MAX_LIMIT }
            body      = ->(limit, offset) { send(api, options.merge!({ offset: offset, limit: limit })) }
            paginator = Paginator::new(body: body, preload: preload, limit: limit)
            instance_variable_set(instance_name, paginator)
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

    def reset_paginators
      Array(self.class.instance_variable_get(:@paginated_apis)).each do |api|
        instance_variable_set(:"@#{api}_paginator", nil)
      end
    end
  end
end
