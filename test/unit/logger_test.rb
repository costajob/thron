require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'logger')

describe Thron do
  before { Thron.reset_logger }

  it 'must define logger once' do
    Thron::logger(enabled: true).object_id.must_equal Thron::logger(enabled: true).object_id
  end

  it 'must be an instance of logger' do
    Thron::logger(enabled: true).must_be_instance_of Logger
  end

  it 'must return a null object if disabled' do
    Thron::logger(enabled: false).must_be_instance_of Thron::NullObj
  end
end
