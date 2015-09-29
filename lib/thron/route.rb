module Thron
  class Route
    attr_reader :verb, :url

    module TYPES
      %w[json plain].each do |type|
        const_set(type.upcase, type)
      end
    end

    module VERBS
      %w[post get].each do |type|
        const_set(type.upcase, type)
      end
    end

    def self.factory(name:, package:, extra: [], verb: VERBS::POST, json: true)
      url = "/#{package}/#{name}"
      url << "/#{extra.join('/')}" unless extra.empty?
      type = json ? TYPES::JSON : TYPES::PLAIN
      Route::new(verb: verb, url: url, type: type)
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

    def json?
      @type == TYPES::JSON
    end

    def headers(token_id: nil, dash: nil)
      @headers ||= { 
        'Accept' => content_type, 
        content_type_key(dash) => content_type 
      }.tap do |headers|
        headers.merge!({ 'X-TOKENID' => token_id }) if token_id
      end
    end

    private def content_type_key(dash = nil)
      "Content_Type".tap do |key|
        key.sub!('_', '-') if dash
      end
    end
  end
end

