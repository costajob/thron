require 'test_helper'
require Thron.root.join('lib', 'thron', 'gateway', 'access_manager')

describe Thron::Gateway::AccessManager do
  let(:klass) { Thron::Gateway::AccessManager }
  let(:instance) { klass::new }

  it 'must set the package' do
    klass.package.to_s.must_equal "xsso/resources/accessmanager"
  end

  it 'must initialize state' do
    assert instance.instance_variable_defined?(:@client_id)
  end
end
