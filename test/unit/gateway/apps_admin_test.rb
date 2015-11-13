require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'apps_admin')

describe Thron::Gateway::AppsAdmin do
  let(:klass) { Thron::Gateway::AppsAdmin }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:app_id) { '184f842e-8ca2-4c26-9bfd-719a85a2a73f' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/appsadmin"
  end

  it 'must call post to add group to the app' do
    route = klass.routes.fetch(:add_group_app)
    capabilities = entity::new(add_capabilities: [], add_user_roles: Array::new(3) { |i| "APP#{i}_MANAGER" })
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      groupId: '666',
      userCaps: capabilities.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_group_app(app_id: app_id, group_id: '666', capabilities: capabilities)
  end

  it 'must call post to add snippet to the app' do
    route = klass.routes.fetch(:add_snippet)
    data = entity::new(vesrion: 1.3, status: 'active', snippet_type: 'STANDARD', display_name: 'snippet_1', description: 'standard snippet 1')
    capabilities = entity::new(add_capabilities: [], add_user_roles: Array::new(3) { |i| "APP#{i}_MANAGER" })
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      snippet: data.to_payload,
      caps: capabilities.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_snippet(app_id: app_id, data: data, capabilities: capabilities)
  end

  it 'must call post to add user to the app' do
    route = klass.routes.fetch(:add_user_app)
    capabilities = entity::new(add_capabilities: [], add_user_roles: Array::new(3) { |i| "APP#{i}_MANAGER" })
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      username: 'elvis',
      userCaps: capabilities.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_user_app(app_id: app_id, username: 'elvis', capabilities: capabilities)
  end

  it 'must call post to create a new app' do
    route = klass.routes.fetch(:create_app)
    data = entity::new(pretty_id: 'BLUE-SUEDE-666', app_type: 'GRAMMY_WINNER', active: true, display_name: 'blue suede shoes', description: 'dont you step on my blue suede shoes', can_disguise: true)
    options = entity::new(root_category_id: '666', caps: { add_capabilities: [], add_user_roles: Array::new(3) { |i| "APP#{i}_MANAGER" } })
    body = { 
      clientId: instance.client_id, 
      app: data.to_payload,
      options: options.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_app(data: data, options: options)
  end

  it 'must call post to remove an existing app' do
    route = klass.routes.fetch(:remove_app)
    body = { 
      clientId: instance.client_id, 
      appId: app_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_app(app_id: app_id)
  end

  it 'must call post to remove group from the app' do
    route = klass.routes.fetch(:remove_group_app)
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      groupId: '666'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_group_app(app_id: app_id, group_id: '666')
  end

  it 'must call post to remove snippet from the app' do
    route = klass.routes.fetch(:remove_snippet)
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      snippetId: '666'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_snippet(app_id: app_id, snippet_id: '666')
  end

  it 'must call post to remove user to the app' do
    route = klass.routes.fetch(:remove_user_app)
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      username: 'elvis'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_user_app(app_id: app_id, username: 'elvis')
  end

  it 'must call post to update an existing app' do
    route = klass.routes.fetch(:update_app)
    data = entity::new(pretty_id: 'BLUE-SUEDE-666', app_type: 'GRAMMY_WINNER', active: true, display_name: 'blue suede shoes', description: 'dont you step on my blue suede shoes', can_disguise: true)
    capabilities = entity::new(capabilities: [], roles: Array::new(3) { |i| "APP#{i}_MANAGER" })
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      update: data.to_payload,
      caps: capabilities.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_app(app_id: app_id, data: data, capabilities: capabilities)
  end

  it 'must call post to update an existing snippet' do
    route = klass.routes.fetch(:update_snippet)
    data = entity::new(vesrion: 1.3, status: 'active', snippet_type: 'STANDARD', display_name: 'snippet_1', description: 'standard snippet 1')
    capabilities = entity::new(add_capabilities: [], add_user_roles: Array::new(3) { |i| "APP#{i}_MANAGER" })
    body = { 
      clientId: instance.client_id, 
      appId: app_id,
      snippetId: '666',
      snippet: data.to_payload,
      caps: capabilities.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_snippet(app_id: app_id, snippet_id: '666', data: data, capabilities: capabilities)
  end
end
