require 'test_helper'
require 'thron/gateway/content_category'

describe Thron::Gateway::ContentCategory do
  let(:klass) { Thron::Gateway::ContentCategory }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/contentcategory"
  end

  Thron::Gateway::ContentCategory.routes.keys.each do |message|
    it "must call post to #{message.to_s.split('_').join(' ')}" do
      route = klass.routes.fetch(message)
      query = { 
        clientId: instance.client_id,
        categoryId: '666',
        contentId: '667',
        applyAcl: false
      }
      mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, category_id: '666', content_id: '667')
    end
  end
end
