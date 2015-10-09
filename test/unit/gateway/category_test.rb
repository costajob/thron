require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'category')

describe Thron::Gateway::Category do
  let(:klass) { Thron::Gateway::Category }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:cat_id) { '666' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/category"
  end

  it 'must call post to add locale data' do
    route = klass.routes.fetch(:add_locale)
    locale = Thron::Entity::new(name: 'italiano', locale: 'IT')
    body = { 
      client: { clientId: instance.client_id },
      catId: cat_id,
      catLocale: locale.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_locale(id: cat_id, locale: locale)
  end

  it 'must call post to find category by properties' do
    route = klass.routes.fetch(:find)
    criteria = Thron::Entity::new(text_search: 'blue suede shoes')
    body = { 
      client: { clientId: instance.client_id },
      properties: criteria.to_payload,
      locale: nil,
      orderBy: nil,
      offset: 0,
      numberOfResult: 0
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find(criteria: criteria)
  end
end
