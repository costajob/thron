require_relative 'logger'

module Thron
  class Response
    attr_reader :http_code, :body, :result_code, :sso_code, :error

    class NotTwoHundredError < StandardError; end

    def initialize(raw)
      @http_code   = raw.code
      @body        = fetch_body(raw)
      @result_code = body.delete('resultCode')
      @sso_code    = body.delete('ssoCode')
      @error       = body.delete('errorDescription')
      check_http_code
    end

    private

    def fetch_body(raw)
      raw.parsed_response || {}
    end

    def check_http_code
      fail NotTwoHundredError, @body.to_s unless is_200?
    end

    def is_200?
      (@http_code.to_i / 100) == 2
    end
  end
end
