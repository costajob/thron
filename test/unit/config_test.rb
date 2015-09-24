require 'test_helper'
require Thron::root.join('lib', 'thron', 'config')

describe Thron::Config do
  it 'must dump yaml' do
    Thron::Config::dump_yaml.must_be_instance_of Hash
  end

  it 'must valorize the cache object' do
    %i[redis_url enabled].each do |message|
      Thron::Config::cache.send(message).wont_be_nil
    end
  end 

  it 'must valorize the logger_level' do
    Thron::Config::logger_level.must_equal Logger::WARN
  end

  it 'must valorize the Thron configuration' do
    %i[username password client_id app_id base_url].each do |message|
      Thron::Config::thron.send(message).wont_be_nil
    end
  end
end
