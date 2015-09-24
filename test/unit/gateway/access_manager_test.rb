require 'test_helper'
require Thron.root.join('lib', 'thron', 'gateway', 'access_manager')

describe Thron::Gateway::AccessManager do
  let(:klass) { Thron::Gateway::AccessManager }

  it 'must set the package' do
    klass.package.to_s.must_equal "xsso/resources/accessmanager"
  end
end
