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

      attr_accessor :token_id

      def self.service_name
        self.name.split('::').last.downcase
      end

      def self.package
        fail NotImplementedError
      end

      private def check_session
        fail NoActiveSessionError unless token_id
      end
    end
  end
end
