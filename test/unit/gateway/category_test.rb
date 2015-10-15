require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'category')

describe Thron::Gateway::Category do
  let(:klass) { Thron::Gateway::Category }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:category_id) { '32636c5f-b5d7-4800-8653-f4abff63f67b' }
  let(:parent_id) { 'd8e0e4cf-4e3d-4d79-8fba-972ee6b67822' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/category"
  end

  it 'must call post to create category' do
    route = klass.routes.fetch(:create)
    body = { 
      client: {
        clientId: instance.client_id
      },
      upCatId: category_id,
      catLocales: {},
      isPrivate: true,
      private: true,
      solution: nil,
      options: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create(parent_id: category_id, is_private: true)
  end

  it 'must call post to create system category' do
    route = klass.routes.fetch(:create_system)
    body = { 
      client: {
        clientId: instance.client_id
      },
      newCategoryId: category_id,
      upCatId: parent_id,
      catLocales: {},
      options: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_system(id: category_id, parent_id: parent_id)
  end

  it 'must call post to create locale' do
    route = klass.routes.fetch(:create_locale)
    locale = Thron::Entity::Base::new(name: 'italiano', locale: 'IT')
    body = { 
      client: { clientId: instance.client_id },
      catId: category_id,
      catLocale: locale.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_locale(id: category_id, locale: locale)
  end

  it 'must call post to create pretty id' do
    route = klass.routes.fetch(:create_pretty_id)
    pretty_id = Thron::Entity::Base::new(id: '678', locale: 'IT')
    body = { 
      clientId: instance.client_id,
      categoryId: category_id,
      prettyId: pretty_id.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_pretty_id(id: category_id, pretty_id: pretty_id)
  end

  it 'must call post to find category by properties' do
    route = klass.routes.fetch(:find)
    criteria = Thron::Entity::Base::new(text_search: 'blue suede shoes')
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

  it 'must call get to fetch category detail' do
    route = klass.routes.fetch(:detail)
    query = {
      clientId: instance.client_id,
      categoryId: category_id,
      cascade: false,
      locale: nil
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.detail(id: category_id)
  end

  it 'must call post to remove category' do
    route = klass.routes.fetch(:remove)
    query = {
      clientId: instance.client_id,
      catId: category_id,
      cascade: true
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.remove(id: category_id, recursive: true)
  end

  it 'must call post to remove locale' do
    route = klass.routes.fetch(:remove_locale)
    body = { 
      client: { clientId: instance.client_id },
      catId: category_id,
      locale: 'en'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_locale(id: category_id, locale: 'en')
  end

  it 'must call post to remove pretty id' do
    route = klass.routes.fetch(:remove_pretty_id)
    body = { 
      clientId: instance.client_id,
      categoryId: category_id,
      locale: 'en'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_pretty_id(id: category_id, locale: 'en')
  end

  it 'must call post to set parent category' do
    route = klass.routes.fetch(:set_parent)
    query = {
      clientId: instance.client_id,
      categoryId: category_id,
      categoryParentId: parent_id
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.set_parent(id: category_id, parent_id: parent_id)
  end

  it 'must call post to update category data' do
    route = klass.routes.fetch(:update)
    body = { 
      client: { clientId: instance.client_id },
      categoryId: category_id,
      update: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update(id: category_id)
  end

  it 'must call post to update locale' do
    route = klass.routes.fetch(:update_locale)
    body = { 
      client: { clientId: instance.client_id },
      catId: category_id,
      property: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_locale(id: category_id)
  end

  it 'must call post to update pretty id' do
    route = klass.routes.fetch(:update_pretty_id)
    body = { 
      clientId: instance.client_id,
      categoryId: category_id,
      prettyId: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_pretty_id(id: category_id)
  end
end
