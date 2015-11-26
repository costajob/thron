require 'test_helper'
require 'thron/gateway/delivery'

describe Thron::Gateway::Delivery do
  let(:klass) { Thron::Gateway::Delivery }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/delivery"
  end

  it 'must call get to fetch content metadata' do
    route = klass.routes.fetch(:content_metadata)
    criteria = entity::new(locale: 'en', linked_channel_type: 'CH-666', linked_user_agent: 'Mozilla', div_area: '125x500', pkey: 'KEY-666', lcid: 'ID-666').to_payload
    query = {
      clientId: instance.client_id,
      xcontentId: '666',
    }.merge!(criteria)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.content_metadata(content_id: '666', criteria: criteria)
  end

  %i[content_cuepoints downloadable_contents playlist_contents].each do |message|
    it "must call get to fetch #{message.to_s.split('_').join(' ')}" do
      route = klass.routes.fetch(message)
      criteria = entity::new(xpublisher_id: 'ELVIS-666', locale: 'en', linked_channel_type: 'CH-666', linked_user_agent: 'Mozilla', div_area: '125x500', pkey: 'KEY-666', admin: true).to_payload
      query = {
        clientId: instance.client_id,
        xcontentId: '666',
        offset: 0,
        numberOfResult: 0
      }.merge!(criteria)
      mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, content_id: '666', criteria: criteria, offset: 0, limit: 0)
    end
  end

  it 'must call get to fetch recommended contents' do
    route = klass.routes.fetch(:recommended_contents)
    criteria = entity::new(xpublisher_id: 'ELVIS-666', locale: 'en', linked_channel_type: 'CH-666', linked_user_agent: 'Mozilla', div_area: '125x500', admin: true).to_payload
    query = {
      clientId: instance.client_id,
      xcontentId: '666',
      pkey: 'KEY-666',
      offset: 0,
      numberOfResult: 0
    }.merge!(criteria)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.recommended_contents(content_id: '666', pkey: 'KEY-666', criteria: criteria, offset: 0, limit: 0)
  end

  it 'must call get to fetch content subtitles' do
    route = klass.routes.fetch(:content_subtitles)
    criteria = entity::new(pkey: 'KEY-666', lcid: 'ID-666').to_payload
    query = {
      clientId: instance.client_id,
      xcontentId: '666',
      locale: 'en'
    }.merge!(criteria)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.content_subtitles(content_id: '666', locale: 'en', criteria: criteria)
  end

  it 'must call get to fetch content thumbnail' do
    route = klass.routes.fetch(:content_thumbnail).call([instance.client_id, '125x600', '666.jpg'])
    mock(klass).get(route.url, { query: {}, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.content_thumbnail(content_id: '666.jpg', div_area: '125x600')
  end
end
