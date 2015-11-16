require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'content_list')

describe Thron::Gateway::ContentList do
  let(:klass) { Thron::Gateway::ContentList }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/contentlist"
  end

  it 'must call get to show contents' do
    route = klass.routes.fetch(:show_contents)
    criteria = entity::new(type: 'VIDEO', search_key: 'test', ugc: false).to_payload
    query = {
      clientId: instance.client_id,
      categoryId: '64746',
      locale: 'EN',
      searchOnSubCategories: false,
      orderBy: 'name',
      offset: 0,
      numberOfResult: 0
    }.merge(criteria)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.show_contents(category_id: '64746', locale: 'EN', criteria: criteria, recursive: false, order_by: 'name')
  end
end
