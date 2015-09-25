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
    let(:get_route) { Thron::Route::new(verb: 'get', url: '/get_route', type: 'json') }
    let(:post_route) { Thron::Route::new(verb: 'post', url: '/post_route', type: 'json') }
    let(:query) { { select: 'all' } }
    let(:headers) { { cachable: true } }

    it 'must call the get method' do
      mock(Mock::Assets).get('/get_route', { query: query, headers: headers.merge(get_route.headers) }) { true }
      assert routable.call(route: get_route, query: query, headers: headers) 
    end

    it 'must call the post method' do
      mock(Mock::Assets).post('/post_route', { query: query, headers: post_route.headers }) { true }
      assert routable.call(route: post_route, query: query) 
    end
  end
end
