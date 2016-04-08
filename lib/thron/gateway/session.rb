require 'thron/gateway/base'
require 'thron/pageable'

module Thron
  module Gateway
    class Session < Base
      include Pageable

      def initialize(options = {})
        token_id = options[:token_id]
        @token_id = token_id
      end
    end
  end
end
