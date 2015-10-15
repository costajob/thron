require 'test_helper'
require Thron::root.join('lib', 'thron', 'paginator')

module Mock
  class Gateway
    def find(total: 1225, limit: 0, offset: 0)
      max = (offset+limit) >= total ? total : (offset+limit)
      OpenStruct::new(total: total,  res: (offset..max).to_a)
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

  describe '#prev, #next and #to' do
    { prev: nil, next: nil, to: 4 }.each do |message, args|
      it "must set total and pages properly on #{message}" do
        instance.send(message, *args)
        instance.total.must_equal 1225
        instance.pages.must_equal 25
      end
    end

    { prev: nil, next: nil, to: 1 }.each do |message, args|
      it "must detect first page on #{message}" do
        instance.send(message, *args)
        assert instance.first?
      end
    end

    it 'must set the offset' do
      3.times { instance.next }
      instance.prev
      instance.to(1)
      instance.offset.must_equal 0
    end

    it 'must fetch results' do
      instance.next
      instance.next.res.must_equal (50..100).to_a
      instance.prev.res.must_equal (0..50).to_a
      instance.to(7).res.must_equal (300..350).to_a
    end

    it 'must limit previous offset' do
      3.times { instance.prev }
      instance.offset.must_equal 0
    end

    it 'must limit next offset' do
      100.times { instance.next }
      instance.offset.must_equal 1200
      assert instance.last?
    end

    it 'must limit max page once total is known' do
      instance.next
      instance.to(100)
      instance.offset.must_equal 1200
      assert instance.last?
    end

    it 'must set cache' do
      instance.next
      instance.instance_variable_get(:@cache).fetch(0).must_be_instance_of OpenStruct
    end

    it 'must read the cache first' do
      instance.next.equal? instance.prev
    end

    it 'must set get the page' do
      instance.to(2)
      instance.page.must_equal 2
    end
  end

  describe '#preload' do
    it 'must return itself after preload' do
      instance.preload.must_equal instance
    end

    it 'must limit preloading' do
      instance.preload
      instance.instance_variable_get(:@cache).size.must_equal klass::PRELOAD_LIMIT
    end 

    it 'must limit preload to available results' do
      150.times { instance.preload }
      instance.instance_variable_get(:@cache).size.must_equal 25
      assert instance.last?
    end
  end
end
