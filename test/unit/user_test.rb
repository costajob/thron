require 'test_helper'
require Thron::root.join('lib', 'thron', 'user')

describe Thron::User do
  let(:klass) { Thron::User }
  let(:instance) { klass::new }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }

  it 'must initialize state' do
    %w[access_gateway].each do |attr|
      assert instance.instance_variable_defined?(:"@#{attr}")
    end
  end

  it 'must delegate access methods to the gateway' do
    %i[login logout validate_token validate_roles validate_capabilities].each do |message|
      instance.must_respond_to message
    end
  end

  it 'must set gateways on each login' do
    gateway = instance.instance_variable_get(:@access_gateway)
    stub(gateway).login { gateway.token_id = token_id }
    instance.login({})
    instance.instance_variable_get(:@gateways).must_be_instance_of Hash
  end
end
