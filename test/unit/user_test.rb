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

  it 'must prevent state set if logon fails' do
    stub(access_gateway).login { :not_logged }
    instance.login({})
    refute instance.token_id
    refute instance.gateways
  end

  it 'must set gateways on login' do
    instance.login({})
    assert instance.gateways.values.all? { |gateway| gateway.token_id == token_id }
  end

  it 'must update gateways on successive login' do
    instance.login({})
    old_gateways_ids = instance.gateways.values.map(&:object_id)
    new_token_id = '944a2e43-985f-426f-951a-b479ea1a82f6'
    stub(access_gateway).login { access_gateway.token_id = new_token_id }
    instance.login({})
    new_gateways_ids = instance.gateways.values.map(&:object_id)
    old_gateways_ids.must_equal new_gateways_ids
    assert instance.gateways.values.all? { |gateway| gateway.token_id == new_token_id }
  end

  it 'must clear state on logout' do
    instance.login({})
    instance.logout
    instance.token_id.must_be_nil
    instance.gateways.must_be_nil
  end

  it 'must prevent logout of unlogged user' do
    refute instance.logout
  end

  it 'must disguise via app' do
    new_token_id = '944a2e43-985f-426f-951a-b479ea1a82f6'
    stub(instance).su { OpenStruct::new(body: { id: new_token_id }) }
    instance.login({})
    instance.disguise(app_id: 'in_the_ghetto', username: 'elvis') do
      instance.token_id.must_equal new_token_id
      assert instance.gateways.values.all? { |gateway| gateway.token_id == new_token_id }
    end
    instance.token_id.must_equal token_id
    assert instance.gateways.values.all? { |gateway| gateway.token_id == token_id }
  end

  it 'must return a benign value if cannot disguise' do
    error = 'Beatles does not perform live anymore!'
    stub(instance).su { OpenStruct::new(body: {}, error: error) }
    instance.login({})
    instance.disguise(app_id: 'here_come_the_sun', username: 'george').must_equal error
  end

  it 'must delegate methods to the access gateway instance' do
    access_gateway.class.routes.keys.each do |message|
      instance.must_respond_to message
    end
  end

  Thron::User::session_gateways.each do |name|
    it "must delegate methods to the #{name} gateway" do
      gateway = Thron::Gateway.const_get(name)
      (gateway.routes.keys + gateway.paginator_methods).each do |message|
        instance.must_respond_to message
      end
    end
  end
end
