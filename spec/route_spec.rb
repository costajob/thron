require 'spec_helper'
require 'thron/route'

describe Thron::Route do
  let(:klass) { Thron::Route }
  let(:json) { klass::new(verb: 'post', url: '/json_api', type: 'json', accept: 'json') }
  let(:text) { klass::new(verb: 'get', url: '/text_api', type: 'plain', accept: 'json') }

  it 'must define type constants' do
    %w[json xml plain multipart].each do |type|
      klass::Types.const_get(type.upcase).wont_be_nil
    end
  end

  it 'must define verb constants' do
    %w[post get].each do |type|
      klass::Verbs.const_get(type.upcase).wont_be_nil
    end
  end

  it 'must raise an error for unsupported verb' do
    -> { klass::new(verb: 'options', url: '/json_api', type: 'json', accept: 'plain') }.must_raise klass::UnsupportedVerbError
  end

  it 'must raise an error for unsupported type' do
    -> { klass::new(verb: 'get', url: '/text_api', type: 'text', accept: 'plain') }.must_raise klass::UnsupportedTypeError
    -> { klass::new(verb: 'get', url: '/text_api', type: 'plain', accept: 'text') }.must_raise klass::UnsupportedTypeError
  end

  describe '::factory' do
    let(:package) { 'xsso/resources/accessmanager' }

    it 'must create a route with defaults' do
      route = klass::factory(name: :test_me, package: package) 
      route.url.must_equal '/xsso/resources/accessmanager/test_me'
      route.verb.must_equal klass::Verbs::POST
      assert route.json?
    end

    it 'must create a custom route' do
      route = klass::factory(name: :test_me, package: package, params: %w[clientid groupid], verb: klass::Verbs::GET, type: klass::Types::PLAIN, accept: klass::Types::JSON) 
      route.url.must_equal '/xsso/resources/accessmanager/test_me/clientid/groupid'
      route.verb.must_equal klass::Verbs::GET
      refute route.json?
    end

    it 'must return a proc to be evauated' do
      lazy = klass::lazy_factory(name: :test_me, package: package)
      route = lazy.call(%w[param1 param2 param3])
      route.url.must_equal '/xsso/resources/accessmanager/test_me/param1/param2/param3'
      route.verb.must_equal klass::Verbs::POST
      assert route.json?
    end
  end

  it 'must initialize state' do
    %w[verb url type accept].each do |attr|
      assert json.instance_variable_defined?(:"@#{attr}")
    end
  end

  it 'must return itself' do
    json.call('arg1', 'arg2').must_equal json
  end

  it 'must detect JSON type' do
    assert json.json?
  end

  it 'must return appropriate headers' do
    json.headers.must_equal({ "Accept" => "application/json", "Content_Type" => "application/json" })
  end

  it 'must return appropriate headers with token_id' do
    token_id = '4b0a2f5e-2c6f-4d30-a584-ea9788505f9fjj'
    text.headers(token_id: token_id, dash: true).must_equal({ "Accept" => "application/json", "Content-Type" => "text/plain", 'X-TOKENID' => token_id })
  end
end
