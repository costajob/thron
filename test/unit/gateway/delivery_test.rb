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
    data = entity::new(content_id: '666', locale: 'en', linked_channel_type: 'CH-666', linked_user_agent: 'Mozilla', div_area: '125x500', pkey: 'KEY-666', lcid: 'ID-666')
    query = {
      clientId: instance.client_id,
      xcontentId: data.content_id,
      locale: data.locale,
      linkedChannelType: data.linked_channel_type,
      linkedUserAgent: data.linked_user_agent,
      divArea: data.div_area,
      pkey: data.pkey,
      lcid: data.lcid
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.content_metadata(data.to_h)
  end

  it 'must call get to fetch content cuepoints' do
    route = klass.routes.fetch(:content_cuepoints)
    data = entity::new(content_id: '6666', publisher_id: 'ELVIS-666', cuepoint_types: Array::new(3) { |i| "TYPE-#{i}" }, actions: Array::new(4) { |i| "ACT-#{i}" }, start_time: (Time.now - 60*60).to_i, end_time: Time.now.to_i, draft: true, username: 'elvis', cuepoint_group: 'blue suede shoes', pkey: 'KEY-666', lcid: 'ID-666')
    query = { 
      clientId: instance.client_id,
      xcontentId: data.content_id,
      xpublisherId: data.publisher_id,
      cuePointTypes: data.cuepoint_types,
      actions: data.actions,
      startTime: data.start_time,
      endTime: data.end_time,
      draft: data.draft,
      username: data.username,
      cuePointGroup: data.cuepoint_group,
      pkey: data.pkey,
      lcid: data.lcid,
      offset: 0,
      numberOfResult: 0
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.content_cuepoints(data.to_h.merge!(offset: 0, limit: 0))
  end

  it 'must call get to fetch downloadable contents' do
    route = klass.routes.fetch(:downloadable_contents)
    data = entity::new(content_id: '666', publisher_id: 'ELVIS-666', locale: 'en', admin: true, div_area: '125x500', pkey: 'KEY-666', lcid: 'ID-666')
    query = {
      clientId: instance.client_id,
      xpublisherId: data.publisher_id,
      xcontentId: data.content_id,
      locale: data.locale,
      admin: data.admin,
      divArea: data.div_area,
      pkey: data.pkey,
      lcid: data.lcid,
      offset: 0,
      numberOfResult: 0
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.downloadable_contents(data.to_h.merge!(offset: 0, limit: 0))
  end
end
