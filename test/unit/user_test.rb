require 'test_helper'
require Thron::root.join('lib', 'thron', 'user')

describe Thron::User do
  let(:klass) { Thron::User }
  let(:username) { 'elvis' }
  let(:password) { 'dont-be-cruel' }
  let(:instance) { klass::new(username: username, password: password) }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }

  it 'must initialize state' do
    %w[username password].each do |attr|
      assert instance.instance_variable_defined?(:"@#{attr}")
    end
  end

  it 'must login' do
    mock(instance.access_gateway).login(username: username, password: password) { instance.access_gateway.token_id = token_id }
    instance.login
    instance.instance_variable_get(:@token_id).must_equal token_id
  end

  it 'must delegate access methods to the gateway' do
    %i[logout validate_token validate_roles validate_capabilities].each do |message|
      instance.must_respond_to message
    end
  end
end
