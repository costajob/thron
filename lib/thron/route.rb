module Thron
  class Route
    module Types
      ALL = %w[json plain]
      ALL.each do |type|
        const_set(type.upcase, type)
      end
    end

    module Verbs
      ALL = %w[post get put delete]
      ALL.each do |type|
        const_set(type.upcase, type)
      end
    end

    class UnsupportedVerbError < StandardError; end
    class UnsupportedTypeError < StandardError; end

    def self.factory(name:, package:, params: [], verb: Verbs::POST, json: true, format: nil)
      url = "/#{package}/#{name}"
      url << "/#{params.join('/')}" unless params.empty?
      type = json ? Types::JSON : Types::PLAIN
      Route::new(verb: verb, url: url, type: type, format: format)
    end

    def self.lazy_factory(args)
      args.delete(:params)
      ->(params) { factory(args.merge({ params: params })) }
    end

    attr_reader :verb, :url

    def initialize(verb:, url:, type:, format: nil)
      @verb   = check_verb(verb)
      @url    = url
      @type   = check_type(type)
      @format = format
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

    def format
      return {} unless @format
      { format: @format }
    end

    def headers(token_id: nil, dash: nil)
      @headers = { 
        'Accept' => content_type, 
        content_type_key(dash) => content_type 
      }.tap do |headers|
        headers.merge!({ 'X-TOKENID' => token_id }) if token_id
      end
    end

    private
    
    def content_type_key(dash = nil)
      "Content_Type".tap do |key|
        key.sub!('_', '-') if dash
      end
    end

    def check_verb(verb)
      verb.tap do |verb|
        fail UnsupportedVerbError, "#{verb} is not supported" unless Verbs::ALL.include?(verb)
      end
    end

    def check_type(type)
      type.tap do |type|
        fail UnsupportedTypeError, "#{type} is not supported" unless Types::ALL.include?(type)
      end
    end
  end
end

