require_relative 'logger'

module Thron
  class Response
    attr_reader :result_code, :sso_code, :error

    class NotTwoHundredError < StandardError; end
    class ResponseNotParsedError < StandardError; end

    def initialize(raw_response)
      @raw = raw_response
      check_http_code
      @result_code = parsed.delete('resultCode')
      @sso_code    = parsed.delete('ssoCode')
      @error       = parsed.delete('errorDescription')
    end

    private

    def parsed
      @parsed = @raw.parsed_response
    rescue e
      Thron::logger::error(e)
      fail ResponseNotParsedError, e.message
    end

    def check_http_code
      fail NotTwoHundredError, parsed.to_s unless is_200?
    end

    def is_200?
      (@raw.code.to_i / 100) == 2
    end
  end
end
