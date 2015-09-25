require 'test_helper'
require Thron::root.join('lib', 'thron', 'behaviour', 'routable')

module Mock
  class Assets
    include Thron::Routable
  end
end

describe Thron::Routable do
  let(:klass) { Thron::Routable }

  it 'must define base_url' do
    Mock::Assets::base_url.wont_be_nil
  end

  describe '#call' do
    let(:routable) { Mock::Assets::new }
    let(:get_route) { Thron::Route::new(:get, '/get_route', :json) }
    let(:post_route) { Thron::Route::new(:post, '/post_route', :json) }
    let(:options) { { query: 'all' } }

    it 'must call the get method' do
      mock(Mock::Assets).get('/get_route', options) { true }
      assert routable.call(get_route, options) 
    end

    it 'must call the post method' do
      mock(Mock::Assets).post('/post_route', options) { true }
      assert routable.call(post_route, options) 
    end
  end
end
