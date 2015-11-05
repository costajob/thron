require_relative 'paginator'

module Thron
  module Pageable
    private def fetch_paginator(api_name, args = {})
      instance_name = :"@paginator_for_#{api_name}"
      instance_variable_get(instance_name) || begin
        preload = args.delete(:preload) { 0 }
        limit = args.delete(:limit) { Paginator::MAX_LIMIT }
        body = ->(limit, offset) { send(api_name, args.merge!({ offset: offset, limit: limit })) }
        paginator = Paginator::new(body: body, preload: preload, limit: limit)
        instance_variable_set(instance_name, paginator)
      end
    end
  end
end
