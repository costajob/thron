require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'users_group_manager')

describe Thron::Gateway::UsersGroupManager do
  let(:klass) { Thron::Gateway::UsersGroupManager }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }
  let(:group_id) { '184f842e-8ca2-4c26-9bfd-719a85a2a73f' }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/usersgroupmanager"
  end

  it 'must call post to create a new group' do
    route = instance.routes.fetch(:create)
    body = { 
      clientId: instance.client_id, 
      usersGroup: Thron::Entity::Group::default.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create.must_be_instance_of Thron::Entity::Group
  end

  it 'must call post to remove an existing group' do
    route = instance.routes.fetch(:remove)
    body = { 
      clientId: instance.client_id,
      groupId: group_id,
      force: true
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove(id: group_id, force: true)
  end

  it 'must call post to get group detail' do
    route = instance.routes.fetch(:detail)
    body = { 
      clientId: instance.client_id,
      groupId: group_id,
      offset: 0,
      numberOfResult: 0,
      fieldsOption: Thron::Entity::FieldsOption::default.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.detail(id: group_id).must_be_instance_of Thron::Entity::Group
  end

  it 'must call post to find group by properties' do
    route = instance.routes.fetch(:find)
    body = { 
      clientId: instance.client_id,
      criteria: Thron::Entity::GroupCriteria::default.to_payload,
      orderBy: nil,
      fieldsOption: Thron::Entity::FieldsOption::default.to_payload,
      offset: 0,
      numberOfResult: 0
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find.must_be_instance_of Array
  end

  %i[link_users unlink_users].each do |message|
    it "must call post to #{message.to_s.sub('_', ' ')}" do
      route = instance.routes.fetch(message)
      body = { 
        clientId: instance.client_id,
        userList: {
          usernames: %w[user1 user2]
        },
        groupId: group_id
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, id: group_id, users: %w[user1 user2])
    end
  end

  it 'must call post to update group details' do
    group = Thron::Entity::Group::default.tap do |group|
      group.id = group_id
      group.metadata = 3.times.map { |i| Thron::Entity::Metadata::new(name: "name#{i}", value: "value#{i}") }
    end
    route = instance.routes.fetch(:update).call([instance.client_id, group.id])
    body = { 
      update: group.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update(group: group)
  end

  it 'must call post to update external id' do
    group = Thron::Entity::Group::default.tap do |group|
      group.id = group_id
      group.external_id = Thron::Entity::ExternalId::new(id: 'ext_01', type: 'type_01')
    end
    route = instance.routes.fetch(:update_external_id).call([instance.client_id, group.id])
    body = { 
      externalId: group.external_id.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_external_id(group: group)
  end
end
