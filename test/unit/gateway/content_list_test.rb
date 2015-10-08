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
    route = instance.routes.fetch(:find)
    criteria = Thron::Entity::ContentCriteria::new(type: 'VIDEO')
    query = criteria.to_payload.merge({ 
      clientId: instance.client_id,
      orderBy: nil,
      offset: 0,
      numberOfResult: 0
    })
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find(criteria: criteria)
  end
end
