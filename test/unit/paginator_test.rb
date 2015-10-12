require 'test_helper'
require Thron::root.join('lib', 'thron', 'paginator')

module Mock
  class Gateway
    def find(total: 3200, limit: 0, offset: 0)
      OpenStruct::new(total: total,  res: (1000 + offset))
    end
  end
end

describe Thron::Paginator do
  let(:klass) { Thron::Paginator }
  let(:gateway) { Mock::Gateway::new }
  let(:body) { ->(limit, offset) { gateway.find(limit: limit, offset: offset) } }
  let(:instance) { klass::new(body: body) }

  it 'must initialize state' do
    %i[body limit offset cache preload].each do |attr|
      assert instance.instance_variable_defined?(:"@#{attr}")
    end
  end

  it 'must prevent instantiation for non proc body' do
    -> { klass::new(body: {}) }.must_raise ArgumentError
  end
  
  it 'must prevent instantiation for body that accepts more/less than two arguments' do
    -> { klass::new(body: ->(msg) { puts msg }) }.must_raise ArgumentError
  end

  it 'must prevent instantiation for preload too large' do
    -> { klass::new(body: body, preload: klass::MAX_PRELOAD+1) }.must_raise klass::PreloadTooLargeError
  end

  describe '#prev and #next' do
    it 'must update state properly' do
      instance.next
      instance.instance_variable_get(:@offset).must_equal 1
      instance.total.must_equal 3200
    end

    it 'must move properly' do
      instance.next.res.must_equal 1001
      instance.prev.res.must_equal 1000
    end

    it 'must set cache' do
      instance.next
      instance.instance_variable_get(:@cache).fetch(1).must_be_instance_of OpenStruct
    end

    it 'must read the cache first' do
      instance.next.equal? instance.prev
    end
  end

  describe '#preload' do
    it 'must preload calls properly' do
      instance.preload
      instance.instance_variable_get(:@cache).size.must_equal klass::PRELOAD_LIMIT
    end 

    it 'must preload properly for few results' do
      body = ->(limit, offset) { gateway.find(total: 100, limit: limit, offset: offset) }
      instance = klass::new(body: body, preload: klass::MAX_PRELOAD)
      instance.preload
      instance.instance_variable_get(:@cache).size.must_equal 2
    end
  end
end
