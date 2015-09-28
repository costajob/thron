require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'logger')

describe Thron do
  before { Thron.reset_logger }

  it 'must define logger once' do
    Thron::logger.object_id.must_equal Thron::logger.object_id
  end

  it 'must be an instance of logger' do
    Thron::logger.must_be_instance_of Logger
  end
end
