require 'thron/string_extensions'

module Thron
  using StringExtensions
  class Response
    attr_accessor :body
    attr_reader :http_code, :result_code, :sso_code, :total, :other_results, :error

    ERROR_KEY = 'errorDescription'
    ID_REGEX  = /\A\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\Z/

    def initialize(raw_data)
      @http_code     = raw_data.code
      @body          = fetch(raw_data)
      @result_code   = @body.delete('resultCode')
      @sso_code      = @body.delete('ssoCode')
      @total         = @body.delete('totalResults')
      @other_results = @body.delete('otherResults') { false }
      @error         = @body.delete(ERROR_KEY)
    end

    def extra(options = {})
      attribute = options[:attribute].to_s
      name = attribute.snakecase 
      self.class.send(:attr_reader, name)
      instance_variable_set(:"@#{name}", body.delete(attribute))
    end

    def is_200?
      (@http_code.to_i / 100) == 2
    end

    private

    def fetch(raw_data)
      case(parsed = raw_data.parsed_response)
      when Hash
        parsed
      when ID_REGEX
        { id: parsed }
      when String
        { ERROR_KEY => parsed }
      else
        {}
      end
    end
  end
end
