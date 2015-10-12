require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'v_user_manager')

describe Thron::Gateway::VUserManager do
  let(:klass) { Thron::Gateway::VUserManager }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:username) { 'elvis' }
  let(:password) { 'presley' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/vusermanager"
  end

  it 'must call post to create a new user' do
    route = klass.routes.fetch(:create)
    data = Thron::Entity::Base::new(user_type: 'EXTERNAL_USER')
    body = { 
      clientId: instance.client_id,
      newUser: {
        username: username,
        password: password
      }
    }.merge(data.to_payload).to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create(username: username, password: password, data: data)
  end

  it 'must call get to fetch detail' do
    route = klass.routes.fetch(:detail)
    query = { 
      clientId: instance.client_id,
      username: username,
      offset: 0,
      numberOfResults: 0
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.detail(username: username)
  end
  
  it 'must call post to find users by properties' do
    route = klass.routes.fetch(:find)
    body = { 
      clientId: instance.client_id,
      criteria: Thron::Entity::Base::new(active: true).to_payload,
      orderBy: nil,
      fieldsOption: {},
      offset: 0,
      numberOfResult: 0
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find
  end

  it 'must call post to check user validity' do
    route = klass.routes.fetch(:active?)
    query = { 
      clientId: instance.client_id,
      username: username,
      password: password
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.active?(username: username, password: password)
  end

  it 'must call post to get a temporary token' do
    route = klass.routes.fetch(:temp_token)
    body = { 
      clientId: instance.client_id,
      username: username
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.temp_token(username: username)
  end

  it 'must call post to update password' do
    route = klass.routes.fetch(:update_password)
    query = { 
      clientId: instance.client_id,
      username: username,
      newpassword: password
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.update_password(username: username, password: password)
  end

  it 'must call post to update status' do
    route = klass.routes.fetch(:update_status)
    body = { 
      clientId: instance.client_id,
      username: username,
      properties: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_status(username: username)
  end

  it 'must call post to update capabilities' do
    route = klass.routes.fetch(:update_capabilities)
    body = { 
      clientId: instance.client_id,
      username: username,
      userCapabilities: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_capabilities(username: username)
  end

  it 'must call post to update external id' do
    route = klass.routes.fetch(:update_external_id).call([instance.client_id, username])
    body = { 
      externalId: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_external_id(username: username)
  end

  it 'must call post to update image' do
    file = Tempfile::new('profile.jpg') << "This is the profile image"
    file.rewind
    image = Thron::Entity::Image::new(path: file.path)
    route = klass.routes.fetch(:update_image)
    body = { 
      clientId: instance.client_id,
      username: username,
      buffer: image.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_image(username: username, image: image)
  end

  it 'must call post to update settings' do
    route = klass.routes.fetch(:update_settings)
    body = { 
      clientId: instance.client_id,
      username: username,
      settings: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_settings(username: username)
  end

  it 'must call post to update user data' do
    route = klass.routes.fetch(:update).call([instance.client_id, username])
    body = { 
      update: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update(username: username)
  end

  it 'must call post to upgrade user' do
    password = 'lovemetender'
    route = klass.routes.fetch(:upgrade)
    body = { 
      clientId: instance.client_id,
      username: username,
      newPassword: password,
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.upgrade(username: username, password: password)
  end
end
