require_relative 'base'
Dir[Thron.root.join('lib', 'thron', 'entity', '*.rb')].each { |f| require f }

module Thron
  module Gateway
    class Session < Base
      def initialize(args)
        @token_id = args.delete(:token_id)
        super
        check_session
      end

      private def check_session
        fail NoActiveSessionError, NO_ACTIVE_SESSION unless @token_id
      end
    end
  end
end
