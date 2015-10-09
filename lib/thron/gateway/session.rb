require_relative 'base'
Dir[Thron.root.join('lib', 'thron', 'entity', '*.rb')].each { |f| require f }

module Thron
  module Gateway
    class Session < Base
      def initialize(token_id:)
        @token_id = token_id
      end
    end
  end
end
