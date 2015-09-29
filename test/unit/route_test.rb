require 'test_helper'
require Thron::root.join('lib', 'thron', 'route')

describe Thron::Route do
  let(:json) { Thron::Route::new(verb: 'post', url: '/json_api', type: 'json') }
  let(:text) { Thron::Route::new(verb: 'get', url: '/text_api', type: 'text') }

  it 'must define type constants' do
    %w[json plain].each do |type|
      Thron::Route::TYPES.const_get(type.upcase).wont_be_nil
    end
  end

  it 'must initialize state' do
    %w[verb url type].each do |attr|
      assert json.instance_variable_defined?(:"@#{attr}")
    end
  end

  it 'must return appropriate content type' do
    json.content_type.must_equal 'application/json'
  end

  it 'must detect JSON type' do
    assert json.json?
  end

  it 'must return appropriate headers' do
    text.headers.must_equal({ "Accept" => "text/plain", "Content_Type" => "text/plain" })
  end

  it 'must return appropriate headers with token_id' do
    token_id = '4b0a2f5e-2c6f-4d30-a584-ea9788505f9fjj'
    text.headers(token_id).must_equal({ "Accept" => "text/plain", "Content_Type" => "text/plain", 'X-TOKENID' => token_id })
  end
end
