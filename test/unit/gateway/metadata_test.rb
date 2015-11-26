require 'test_helper'
require 'thron/gateway/metadata'

describe Thron::Gateway::Metadata do
  let(:klass) { Thron::Gateway::Metadata }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }
  let(:data) { entity::new(name: 'title', value: 'Blue Suede Shoes', locale: 'en').to_payload }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/metadata"
  end

  it 'must call post to create a new metadata' do
    route = klass.routes.fetch(:insert_metadata)
    body = { 
      client: { clientId: instance.client_id },
      contentId: '666',
      metadata: data,
      categoryIdForAcl: '667'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.insert_metadata(content_id: '666', data: data, category_id: '667')
  end

  it 'must call post to remove all metadata' do
    route = klass.routes.fetch(:remove_all_metadata)
    body = { 
      clientId: instance.client_id,
      contentId: '666'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_all_metadata(content_id: '666')
  end

  it 'must call post to update multiple metadada' do
    route = klass.routes.fetch(:update_metadata)
    data_list = Array::new(4) { |i| entity::new(name: "title#{i}", value: "The album no. #{i}", locale: 'en').to_payload }
    body = { 
      clientId: instance.client_id,
      contentId: '666',
      metadata: { metadata: data_list },
      categoryIdForAcl: '667'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_metadata(content_id: '666', data_list: data_list, category_id: '667')
  end

  %w[remove update_single].each do |action|
    it "must call post to @{action.split('_').join(' ')} metadata" do
      route = klass.routes.fetch(:"#{action}_metadata")
      body = { 
        clientId: instance.client_id,
        contentId: '666',
        metadata: data
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send("#{action}_metadata", content_id: '666', data: data)
    end
  end
end
