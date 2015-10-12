require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'users_group_manager')

describe Thron::Gateway::UsersGroupManager do
  let(:klass) { Thron::Gateway::UsersGroupManager }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }
  let(:group_id) { '184f842e-8ca2-4c26-9bfd-719a85a2a73f' }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/usersgroupmanager"
  end

  it 'must call post to create a new group' do
    route = klass.routes.fetch(:create)
    data = Thron::Entity::Base::new(active: false)
    body = { 
      clientId: instance.client_id, 
      usersGroup: data.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create(data: data)
  end

  it 'must call post to remove an existing group' do
    route = klass.routes.fetch(:remove)
    body = { 
      clientId: instance.client_id,
      groupId: group_id,
      force: true
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove(id: group_id, force: true)
  end

  it 'must call post to get group detail' do
    route = klass.routes.fetch(:detail)
    body = { 
      clientId: instance.client_id,
      groupId: group_id,
      offset: 0,
      numberOfResult: 0,
      fieldsOption: {}
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.detail(id: group_id)
  end

  it 'must call post to find group by properties' do
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

  %i[link_users unlink_users].each do |message|
    it "must call post to #{message.to_s.sub('_', ' ')}" do
      usernames = %w[user1 user2]
      route = klass.routes.fetch(message)
      body = { 
        clientId: instance.client_id,
        userList: {
          usernames: usernames
        },
        groupId: group_id
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, id: group_id, usernames: usernames)
    end
  end

  it 'must call post to update group details' do
    data = Thron::Entity::Base::new(id: group_id)
    route = klass.routes.fetch(:update).call([instance.client_id, group_id])
    body = { 
      update: data.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update(data: data)
  end

  it 'must call post to update external id' do
    external_id = Thron::Entity::Base::new(id: 'ext_01', type: 'type_01')
    route = klass.routes.fetch(:update_external_id).call([instance.client_id, group_id])
    body = { 
      externalId: external_id.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_external_id(id: group_id, external_id: external_id)
  end
end
