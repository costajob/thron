require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'v_user_manager')

describe Thron::Gateway::VUserManager do
  let(:klass) { Thron::Gateway::VUserManager }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/vusermanager"
  end

  it 'must call post to create a new user' do
    route = instance.routes.fetch(:create)
    default = Thron::Entity::User::default(type: klass::DEFAULT_TYPE)
    body = default.to_payload.tap do |payload|
      payload['newUser'] = payload.delete('credential')
    end.merge({ clientId: instance.client_id }).to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create.must_be_instance_of Thron::Entity::User
  end

  it 'must call post to change password' do
    route = instance.routes.fetch(:change_password)
    query = { 
      clientId: instance.client_id,
      username: 'elvis',
      newpassword: 'lovemetender'
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.change_password(username: 'elvis', password: 'lovemetender')
  end

  it 'must call post to change status' do
    route = instance.routes.fetch(:change_status)
    body = { 
      clientId: instance.client_id,
      username: 'elvis',
      properties: {
        active: false,
        expiryDate: nil
      }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.change_status(username: 'elvis')
  end

  it 'must call get to fetch detail' do
    route = instance.routes.fetch(:detail)
    query = { 
      clientId: instance.client_id,
      username: 'elvis',
      returnItags: false,
      returnImetadata: false,
      offset: 0,
      numberOfResults: 0
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.detail(username: 'elvis').must_be_instance_of Thron::Entity::User
  end
  
  it 'must call post to find users by properties' do
    route = instance.routes.fetch(:find)
    body = { 
      clientId: instance.client_id,
      criteria: Thron::Entity::UserCriteria::default.to_payload,
      orderBy: nil,
      fieldsOption: Thron::Entity::FieldsOption::default.to_payload,
      offset: 0,
      numberOfResult: 0
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find.must_be_instance_of Array
  end

  it 'must call post to check user validity' do
    route = instance.routes.fetch(:active?)
    query = { 
      clientId: instance.client_id,
      username: 'elvis',
      password: 'lovemetender'
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.active?(username: 'elvis', password: 'lovemetender').must_be_instance_of Thron::Entity::User
  end
end
