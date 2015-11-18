require 'test_helper'
require 'thron/gateway/publish_in_weebo_express'

describe Thron::Gateway::PublishInWeeboExpress do
  let(:klass) { Thron::Gateway::PublishInWeeboExpress }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/publishinweeboexpress"
  end
  
  Thron::Gateway::PublishInWeeboExpress.routes.keys.each do |message|
    it "must call post to publish #{message.to_s.split('_').join(' ')}" do
      route = klass.routes.fetch(message)
      body = { 
        clientId: instance.client_id,
        param: {}
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, data: {})
    end
  end
end
