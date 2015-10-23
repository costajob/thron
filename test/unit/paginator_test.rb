require 'test_helper'
require Thron::root.join('lib', 'thron', 'paginator')

module Mock
  class Gateway
    def find(total: 1225, limit: 0, offset: 0)
      max = (offset+limit) >= total ? total : (offset+limit)
      OpenStruct::new(total: total,  res: (offset...max).to_a)
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

  it 'must prevent too large limit' do
    instance = klass::new(body: body, limit: klass::MAX_LIMIT+100)
    instance.limit.must_equal klass::MAX_LIMIT
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
      instance.next.res.must_equal (50..99).to_a
      instance.prev.res.must_equal (0..49).to_a
      instance.to(7).res.must_equal (300..349).to_a
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

    it 'must set get the page' do
      instance.to(2)
      instance.page.must_equal 2
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

    describe 'preloading' do
      let(:instance) { klass::new(body: body, preload: 5) }
      let(:keys_proc) { ->(max) { (0..max*instance.limit).step(instance.limit).to_a } }

      it 'must preload results on start' do
        instance.next
        instance.instance_variable_get(:@cache).keys.must_equal keys_proc[4]
      end

      it 'must prevent preloading when behind threshold' do
        4.times { instance.next }
        instance.instance_variable_get(:@cache).keys.must_equal keys_proc[4]
      end

      it 'must preload next set when over threshold' do
        5.times { instance.next }
        instance.instance_variable_get(:@cache).keys.must_equal keys_proc[9]
      end
    end
  end
end
