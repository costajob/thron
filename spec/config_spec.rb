require 'spec_helper'
require 'thron/config'

describe Thron::Config do
  it 'must dump yaml' do
    Thron::Config::dump_yaml.must_be_instance_of Hash
  end

  it 'must valorize the logger configuration' do
    %i[level verbose].each do |message|
      Thron::Config::logger.send(message).wont_be_nil
    end
  end

  it 'must valorize circuit breaker configuration' do
    Thron::Config::circuit_breaker.threshold.must_be_instance_of Fixnum
  end

  it 'must valorize the Thron configuration' do
    %i[client_id protocol].each do |message|
      Thron::Config::thron.send(message).wont_be_nil
    end
  end
end
