require 'httparty'
require_relative '../config'
require_relative '../behaviour/routable'
require_relative '../behaviour/parallelizable'

module Thron
  module Gateway
    Package = Struct::new(:name, :domain, :service) do
      def to_s
        "#{name}/#{domain}/#{service}"
      end
    end

    class NoActiveSessionError < StandardError; end

    class Base
      include Routable
      include Parallelizable

      def self.service_name
        self.name.split('::').last.downcase
      end

      def self.package
        fail NotImplementedError
      end

      attr_accessor :token_id
      attr_reader :client_id

      def initialize(client_id: Config.thron.client_id)
        @client_id = client_id
      end

      private def check_session
        fail NoActiveSessionError unless token_id
      end
    end
  end
end
