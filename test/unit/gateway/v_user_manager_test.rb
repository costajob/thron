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
end
