require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'users_group_manager')

describe Thron::Gateway::UsersGroupManager do
  let(:klass) { Thron::Gateway::UsersGroupManager }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }
  let(:group_id) { '184f842e-8ca2-4c26-9bfd-719a85a2a73f' }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/usersgroupmanager"
  end

  it 'must call post to create a new group' do
    route = klass.routes.fetch(:create)
    data = entity::new(active: false, group_type: 'PLATFORM', group_capabilities: { capabilities: %w[LIST], user_roles: %w[4ME-CONTENT], enabled_solutions: %w[REMOVE ADD] }, description: 'testing group', name: 'test')
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
    options = entity::new(return_own_acl: false, return_itags: true, return_imetadata: true)
    body = { 
      clientId: instance.client_id,
      groupId: group_id,
      offset: 3,
      numberOfResult: 5,
      fieldsOption: options.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.detail(id: group_id, options: options, offset: 3, limit: 5)
  end

  it 'must call post to find group by properties' do
    route = klass.routes.fetch(:find)
    criteria = entity::new(ids: %w[6746 7777 8765], text_search: 'test', active: true, linked_username: 'redazione', group_roles: %w[READ WRITE], acl: { on_context: 'PLATFORM', rules: %w[RULE1 RULE2] }, group_type: %w[BASIC ADVANCED], external_id: '75857')
    options = entity::new(return_own_acl: false, return_itags: true, return_imetadata: true)
    body = { 
      clientId: instance.client_id,
      criteria: criteria.to_payload,
      orderBy: 'id',
      fieldsOption: options.to_payload,
      offset: 4,
      numberOfResult: 40
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find(criteria: criteria, order_by: 'id', options: options, offset: 4, limit: 40)
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
    route = klass.routes.fetch(:update).call([instance.client_id, group_id])
    data = entity::new(id: group_id, metadata: [{ name: 'label', value: 'testing' }], name: 'testing data group', description: 'group for testing purposes', active: false, patch: [{ op: 'DESC', field: 'name' }])
    body = { 
      update: data.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update(data: data)
  end

  it 'must call post to update external id' do
    external_id = entity::new(id: 'ext_01', type: 'type_01')
    route = klass.routes.fetch(:update_external_id).call([instance.client_id, group_id])
    body = { 
      externalId: external_id.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_external_id(id: group_id, external_id: external_id)
  end
end
