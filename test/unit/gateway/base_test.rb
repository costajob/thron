require 'test_helper'
require Thron::root.join('lib', 'thron', 'gateway', 'base')

describe Thron::Gateway::Base do
  let(:klass) { Thron::Gateway::Base }
  let(:instance) { klass::new }

  it 'must set the service name' do
    klass::service_name.must_equal 'base'
  end

  it 'must set the circuit breaker once' do
    klass::circuit_breaker.object_id.must_equal klass::circuit_breaker.object_id
  end

  it 'must initialize state' do
    assert instance.instance_variable_defined?(:@client_id)
  end
end
