module Thron
  class Route
    attr_reader :verb, :url

    module TYPES
      %w[json plain].each do |type|
        const_set(type.upcase, type)
      end
    end

    def initialize(verb:, url:, type:)
      @verb = verb
      @url  = url
      @type = type
    end

    def content_type
      @content_type ||= case @type.to_s
                        when TYPES::JSON
                          'application/json'
                        else
                          'text/plain'
                        end
    end

    def headers
      @headers ||= { 'Accept' => content_type, 'Content_Type' => content_type }
    end
  end
end

