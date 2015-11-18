require 'test_helper'
require 'thron/logger'

describe Thron do
  let(:file) { Tempfile::new('thron.log') }

  it 'must define logger once' do
    Thron::logger(file: file).object_id.must_equal Thron::logger(file: file).object_id
  end

  it 'must be an instance of logger' do
    Thron::logger(file: file).must_be_instance_of Logger
  end
end
