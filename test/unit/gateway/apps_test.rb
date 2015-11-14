require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'apps')

describe Thron::Gateway::Apps do
  let(:klass) { Thron::Gateway::Apps }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:app_id) { '184f842e-8ca2-4c26-9bfd-719a85a2a73f' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/apps"
  end

  it 'must call post to get app detail' do
    route = klass.routes.fetch(:app_detail)
    body = { 
      clientId: instance.client_id, 
      appId: app_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.app_detail(app_id: app_id)
  end

  it 'must call post to list apps' do
    route = klass.routes.fetch(:list_apps)
    criteria = entity::new(app_type: %w[PLATFORM], app_sub_type: 'INTERNAL', app_ids: %w[id1 id3 id7], app_pretty_ids: %w[34 45 67], app_active: false, app_display_name: 'blue sueder', app_owner_username: 'elvis')
    body = { 
      clientId: instance.client_id,
      criteria: criteria.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.list_apps(criteria: criteria)
  end

  it 'must call post to find apps' do
    route = klass.routes.fetch(:find_apps)
    criteria = entity::new(snippet_ids: %w[id1 id7 id8], snippet_status: %w[CREATED DELETED], snippet_display_name: 'ghetto gun', snippet_type: %w[PLATFORM INTERNAL], snippet_owner_username: 'elvis', app_type: %w[PLATFORM], app_active: false, app_display_name: 'ghetto gun')
    body = { 
      clientId: instance.client_id,
      criteria: criteria.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find_apps(criteria: criteria)
  end

  it 'must call get to login app' do
    route = klass.routes.fetch(:login_app)
    query = {
      clientId: instance.client_id, 
      appId: app_id
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.login_app(app_id: app_id)
  end

  it 'must call get to login snippet' do
    route = klass.routes.fetch(:login_snippet)
    query = {
      clientId: instance.client_id, 
      appId: app_id,
      snippetId: '666'
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.login_snippet(app_id: app_id, snippet_id: '666')
  end

  it 'must call post to impersonate user (su)' do
    route = klass.routes.fetch(:su)
    body = { 
      clientId: instance.client_id,
      appId: app_id,
      username: 'elvis'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.su(app_id: app_id, username: 'elvis')
  end
end
