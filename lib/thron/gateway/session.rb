require_relative '../entity/base'
require_relative 'base'

module Thron
  module Gateway
    class Session < Base
      def initialize(token_id:)
        @token_id = token_id
      end
    end
  end
end
