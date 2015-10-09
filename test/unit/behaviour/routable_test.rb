require 'test_helper'
require Thron::root.join('lib', 'thron', 'behaviour', 'routable')

module Mock
  class Assets
    include Thron::Routable
    def self.routes; {}; end
  end
end

describe Thron::Routable do
  let(:klass) { Thron::Routable }
  let(:instance) { Mock::Assets::new }

  it 'must define base_url' do
    Mock::Assets::base_url.wont_be_nil
  end

  it 'should fail when no route exist' do
    -> { instance.send(:route, {to: :noent }) }.must_raise Thron::Routable::NoentRouteError
  end
end
