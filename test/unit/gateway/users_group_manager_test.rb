require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'users_group_manager')

describe Thron::Gateway::UsersGroupManager do
  let(:klass) { Thron::Gateway::UsersGroupManager }
  let(:instance) { klass::new }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/usersgroupmanager"
  end

  describe 'API methods' do
    let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
    let(:group_id) { '184f842e-8ca2-4c26-9bfd-719a85a2a73f' }

    it 'must raise an exception when calling session-based APIs without token' do
      { create_group: { group: nil }, remove_group: { group_id: nil }, detail_group: { group_id: nil }, find_groups: { criteria: nil } }.each do |message, args|
        -> { instance.send(message, args) }.must_raise Thron::Gateway::NoActiveSessionError
      end
    end

    it 'must call post to create a new group' do
      route = instance.routes.fetch(:create_group)
      body = { 
        clientId: instance.client_id,
        usersGroup: Thron::Entity::Group::default.to_h
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body,  headers: route.headers(token_id: token_id, dash: true) })
      instance.token_id = token_id
      instance.create_group
    end

    it 'must call post to remove an existing group' do
      route = instance.routes.fetch(:remove_group)
      body = { 
        clientId: instance.client_id,
        groupId: group_id,
        force: true
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body,  headers: route.headers(token_id: token_id, dash: true) })
      instance.token_id = token_id
      instance.remove_group(group_id: group_id, force: true)
    end

    it 'must call post to get group detail' do
      route = instance.routes.fetch(:detail_group)
      body = { 
        clientId: instance.client_id,
        groupId: group_id,
        offset: 0,
        numberOfResult: 0,
        fieldsOption: Thron::Entity::FieldsOption::default.to_h
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body,  headers: route.headers(token_id: token_id, dash: true) })
      instance.token_id = token_id
      instance.detail_group(group_id: group_id)
    end

    it 'must call post to find group by properties' do
      route = instance.routes.fetch(:find_groups)
      body = { 
        clientId: instance.client_id,
        criteria: Thron::Entity::GroupCriteria::default.to_h,
        orderBy: nil,
        fieldsOption: Thron::Entity::FieldsOption::default.to_h,
        offset: 0,
        numberOfResult: 0
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body,  headers: route.headers(token_id: token_id, dash: true) })
      instance.token_id = token_id
      instance.find_groups
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
        mock(klass).post(route.url, { query: {}, body: body,  headers: route.headers(token_id: token_id, dash: true) })
        instance.token_id = token_id
        instance.send(message, group_id: group_id, users: %w[user1 user2])
      end
    end
  end
end
