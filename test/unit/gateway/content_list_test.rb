require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'content_list')

describe Thron::Gateway::ContentList do
  let(:klass) { Thron::Gateway::ContentList }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/contentlist"
  end

  it 'must call get to find contents' do
    route = klass.routes.fetch(:find)
    criteria = Thron::Entity::Base::new(type: 'VIDEO')
    query = {
      clientId: instance.client_id,
      orderBy: nil,
      offset: 0,
      numberOfResult: 0
    }.merge(criteria.to_payload)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find(criteria: criteria)
  end
end
