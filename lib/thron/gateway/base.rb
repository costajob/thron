require 'httparty'
require_relative '../entity/base'
require_relative '../routable'

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

      base_uri "#{Config::thron::protocol}://#{Config::thron.client_id}-view.4me.it/api"

      NO_ACTIVE_SESSION = "Please provide a valid token ID"

      def self.service_name
        self.name.split('::').last.downcase
      end

      def self.client_id
        @client_id ||= Config.thron.client_id
      end

      attr_reader :client_id
      attr_accessor :token_id

      def client_id
        self.class.client_id
      end

      private def check_session
        fail NoActiveSessionError, NO_ACTIVE_SESSION unless token_id
      end
    end
  end
end
