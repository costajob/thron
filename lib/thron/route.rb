module Thron
  class Route
    module Types
      ALL = %w[json xml plain multipart]
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

    def self.factory(options = {})
      name = options[:name]
      package = options[:package]
      params = options[:params].to_a
      verb = options.fetch(:verb) { Verbs::POST }
      type = options.fetch(:type) { Types::JSON }
      accept = options.fetch(:accept) { Types::JSON }
      url = "/#{package}/#{name}"
      url << "/#{params.join('/')}" unless params.empty?
      Route::new(verb: verb, url: url, type: type, accept: accept)
    end

    def self.lazy_factory(options)
      options.delete(:params)
      ->(params) { factory(options.merge({ params: params })) }
    end

    def self.header_type(type)
      case type.to_s
      when Types::JSON
        'application/json'
      when Types::XML
        'application/xml'
      when Types::MULTIPART
        'multipart/form-data'
      when Types::PLAIN
        'text/plain'
      end
    end

    attr_reader :verb, :url

    def initialize(options = {})
      @verb   = check_verb(options[:verb])
      @url    = options[:url]
      @type   = check_type(options[:type])
      @accept = check_type(options[:accept])
    end

    def call(*args)
      self
    end

    def json?
      @type == Types::JSON
    end

    def format
      return {} unless @format
      { format: @format }
    end

    def headers(options = {})
      @headers = { 
        'Accept' => self.class.header_type(@accept), 
        content_type_key(options[:dash]) => self.class.header_type(@type)
      }.tap do |headers|
        headers.merge!({ 'X-TOKENID' => options[:token_id] }) if options[:token_id]
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

