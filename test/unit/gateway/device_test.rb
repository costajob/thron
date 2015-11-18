require 'test_helper'
require 'thron/gateway/device'

describe Thron::Gateway::Device do
  let(:klass) { Thron::Gateway::Device }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xdevice/resources/device"
  end

  it 'must call post to connect device' do
    route = klass.routes.fetch(:connect_device)
    ik = entity::new(key: 'garment', value: 'blue suede shoes').to_payload
    body = {
      clientId: instance.client_id,
      deviceId: '666',
      ik: ik,
      contactName: 'elvis'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.connect_device(device_id: '666', ik: ik, contact_name: 'elvis')
  end

  it 'must call post to disconnect device' do
    route = klass.routes.fetch(:disconnect_device)
    body = {
      clientId: instance.client_id,
      deviceId: '666',
      contactId: '667'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.disconnect_device(device_id: '666', contact_id: '667')
  end

  it 'must call get to get device' do
    route = klass.routes.fetch(:get_device)
    query = {
      deviceId: '666',
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.get_device(device_id: '666')
  end
end
