require 'spec_helper'
require 'thron/gateway/base'

describe Thron::Gateway::Base do
  let(:klass) { Thron::Gateway::Base }
  let(:instance) { klass::new }

  it 'must initialize client id at class level' do
    klass.client_id.wont_be_nil
  end

  it 'must set the service name' do
    klass::service_name.must_equal 'base'
  end

  it 'must set the circuit breaker once' do
    klass::circuit_breaker.object_id.must_equal klass::circuit_breaker.object_id
  end

  it 'must set client id at instance level too' do
    instance.client_id.must_equal klass::client_id
  end
end
