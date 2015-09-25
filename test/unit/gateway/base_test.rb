require 'test_helper'
require Thron::root.join('lib', 'thron', 'gateway', 'base')

describe Thron::Gateway::Base do
  let(:klass) { Thron::Gateway::Base }
  let(:instance) { klass::new }

  it 'must set the service name' do
    klass::service_name.must_equal 'base'
  end

  it 'should fail when no route exist' do
    -> { instance.route(:noent) }.must_raise Thron::Gateway::Base::NoentRouteError
  end
end
