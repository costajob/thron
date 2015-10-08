module Thron
  class Route
    attr_reader :verb, :url

    module Types
      %w[json plain].each do |type|
        const_set(type.upcase, type)
      end
    end

    module Verbs
      %w[post get].each do |type|
        const_set(type.upcase, type)
      end
    end

    def self.factory(name:, package:, params: [], verb: Verbs::POST, json: true)
      url = "/#{package}/#{name}"
      url << "/#{params.join('/')}" unless params.empty?
      type = json ? Types::JSON : Types::PLAIN
      Route::new(verb: verb, url: url, type: type)
    end

    def self.lazy_factory(args)
      args.delete(:params)
      ->(params) { factory(args.merge({ params: params })) }
    end

    def initialize(verb:, url:, type:)
      @verb = verb
      @url  = url
      @type = type
    end

    def call(*args)
      self
    end

    def content_type
      @content_type ||= case @type.to_s
                        when Types::JSON
                          'application/json'
                        else
                          'text/plain'
                        end
    end

    def json?
      @type == Types::JSON
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

