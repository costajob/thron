require 'test_helper'
require Thron::root.join('lib', 'thron', 'user')

describe Thron::User do
  let(:klass) { Thron::User }
  let(:instance) { klass::new }
  let(:access_gateway) { instance.instance_variable_get(:@access_gateway) }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:gateways) { -> { instance.instance_variable_get(:@gateways) } }
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
    refute gateways.call
  end

  it 'must set gateways on login' do
    instance.login({})
    assert gateways.call.values.all? { |gateway| gateway.token_id == token_id }
  end

  it 'must update gateways on successive login' do
    instance.login({})
    old_gateways_ids = gateways.call.values.map(&:object_id)
    new_token_id = '944a2e43-985f-426f-951a-b479ea1a82f6'
    stub(access_gateway).login { access_gateway.token_id = new_token_id }
    instance.login({})
    new_gateways_ids = gateways.call.values.map(&:object_id)
    old_gateways_ids.must_equal new_gateways_ids
    assert gateways.call.values.all? { |gateway| gateway.token_id == new_token_id }
  end

  it 'must disguise via app' do
    new_token_id = '944a2e43-985f-426f-951a-b479ea1a82f6'
    stub(instance).su { OpenStruct::new(body: { id: new_token_id }) }
    instance.login({})
    instance.disguise(app_id: 'in_the_ghetto', username: 'elvis') do
      instance.token_id.must_equal new_token_id
      assert gateways.call.values.all? { |gateway| gateway.token_id == new_token_id }
    end
    instance.token_id.must_equal token_id
    assert gateways.call.values.all? { |gateway| gateway.token_id == token_id }
  end

  it 'must return a benign value if cannot disguise' do
    stub(instance).su { OpenStruct::new(body: {}) }
    instance.login({})
    instance.disguise(app_id: 'here_come_the_sun', username: 'george').must_equal klass::CANNOT_DISGUISE
  end

  (Thron::User::session_gateways + %i[AccessManager]).each do |name|
    it "must delegate methods to the #{name} gateway" do
      Thron::Gateway.const_get(name).routes.keys.each do |message|
        instance.must_respond_to message
      end
    end
  end
end
