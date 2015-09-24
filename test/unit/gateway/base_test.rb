require 'test_helper'
require Thron::root.join('lib', 'thron', 'gateway', 'base')

describe Thron::Gateway::Base do
  let(:klass) { Thron::Gateway::Base }

  it 'must define base_url' do
    klass::base_url.wont_be_nil
  end

  it 'must set the service name' do
    klass::service_name.must_equal 'base'
  end

  it 'must valorize state' do
    base = klass.new
    %w[options].each do |attr|
      assert base.instance_variable_defined?(:"@#{attr}")
    end
  end
end
