require 'test_helper'
require Thron::root.join('lib', 'thron', 'config')

describe Thron::Config do
  it 'must dump yaml' do
    Thron::Config::dump_yaml.must_be_instance_of Hash
  end

  it 'must valorize the logger configuration' do
    Thron::Config::logger::level.must_be_instance_of Fixnum
    Thron::Config::logger::enabled.wont_be_nil
  end

  it 'must valorize the Thron configuration' do
    %i[client_id base_url].each do |message|
      Thron::Config::thron.send(message).wont_be_nil
    end
  end
end
