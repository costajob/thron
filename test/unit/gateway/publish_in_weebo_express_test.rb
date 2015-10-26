require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'publish_in_weebo_express')

describe Thron::Gateway::PublishInWeeboExpress do
  let(:klass) { Thron::Gateway::PublishInWeeboExpress }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/publishinweeboexpress"
  end
  
  %w[audio content_in_channels document image live_event pagelet playlist program video].each do |message|
    it "must call post to publish #{message}" do
      route = klass.routes.fetch(message.to_sym)
      body = { 
        clientId: instance.client_id,
        param: Thron::Entity::Base::new.to_payload
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message.to_sym, {})
    end
  end
end