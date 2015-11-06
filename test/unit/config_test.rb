require 'test_helper'
require Thron::root.join('lib', 'thron', 'config')

describe Thron::Config do
  it 'must dump yaml' do
    Thron::Config::dump_yaml.must_be_instance_of Hash
  end

  it 'must valorize the logger_level' do
    Thron::Config::logger_level.must_be_instance_of Fixnum
  end

  it 'must valorize the Thron configuration' do
    %i[client_id base_url].each do |message|
      Thron::Config::thron.send(message).wont_be_nil
    end
  end
end
