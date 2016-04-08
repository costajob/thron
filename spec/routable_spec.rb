require 'spec_helper'
require 'thron/routable'

module Mock
  class Assets
    include Thron::Routable
    def self.routes; {}; end
  end
end

describe Thron::Routable do
  let(:klass) { Thron::Routable }
  let(:instance) { Mock::Assets::new }

  it 'should fail when no route exist' do
    -> { instance.send(:route, {to: :noent }) }.must_raise Thron::Routable::NoentRouteError
  end
end
