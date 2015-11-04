require 'test_helper'
require Thron::root.join('lib', 'thron', 'user')

describe Thron::User do
  let(:klass) { Thron::User }
  let(:instance) { klass::new }
  let(:access_gateway) { instance.instance_variable_get(:@access_gateway) }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  before { stub(access_gateway).login { access_gateway.token_id = token_id } }

  it 'must initialize state' do
    %w[access_gateway].each do |attr|
      assert instance.instance_variable_defined?(:"@#{attr}")
    end
  end

  it 'must check logged state' do
    refute instance.logged?
    instance.login({})
    assert instance.logged?
  end

  it 'must return an empty gateways hash if not logged' do
    stub(access_gateway).login { :not_logged }
    instance.login({})
    instance.instance_variable_get(:@gateways).must_be_empty
  end

  it 'must set gateways on login' do
    instance.login({})
    instance.instance_variable_get(:@gateways).each do |name, gateway|
      gateway.token_id.must_equal token_id
    end
  end

  (Thron::User::session_gateways + %i[AccessManager]).each do |name|
    it "must delegate methods to the #{name} gateway" do
      Thron::Gateway.const_get(name).routes.keys.each do |message|
        instance.must_respond_to message
      end
    end
  end
end
