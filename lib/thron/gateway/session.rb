require_relative 'base'
require_relative '../pageable'

module Thron
  module Gateway
    class Session < Base
      include Pageable

      def initialize(token_id:)
        @token_id = token_id
      end
    end
  end
end
