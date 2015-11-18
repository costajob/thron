require 'test_helper'
require Thron::root.join('lib', 'thron', 'paginator')

module Mock
  class Gateway
    def find(total: 1225, other_results: false, limit: 0, offset: 0)
      max = (offset+limit) >= total ? total : (offset+limit)
      OpenStruct::new(total: total,  other_results: other_results, res: (offset...max).to_a)
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

  describe '#prev, #next' do
    %i[prev next].each do |message|
      it "must set total and other_results properly on #{message}" do
        instance.send(message)
        instance.total.must_equal 1225
        refute instance.instance_variable_get(:@other_results)
      end

      it "must detect first page on #{message}" do
        instance.send(message)
        assert instance.first?
      end
    end

    it 'must set the offset' do
      3.times { instance.next }
      instance.prev
      instance.offset.must_equal 50
    end

    it 'must fetch results' do
      instance.next
      instance.next.res.must_equal (50..99).to_a
      instance.prev.res.must_equal (0..49).to_a
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

    it 'must set cache' do
      instance.next
      instance.instance_variable_get(:@cache).fetch(0).must_be_instance_of OpenStruct
    end

    it 'must read the cache first' do
      instance.next.equal? instance.prev
    end

    describe 'other results is true' do
      let(:body) { ->(limit, offset) { gateway.find(total: 0, other_results: true, limit: limit, offset: offset) } }
      let(:instance) { klass::new(body: body) }

      it 'must load next data if total is unknown' do
        3.times { instance.next }
        instance.offset.must_equal 100
      end
    end

    describe 'preloading' do
      let(:instance) { klass::new(body: body, preload: 5) }

      it 'must preload results on start' do
        instance.next
        instance.instance_variable_get(:@cache).keys.must_equal (0..200).step(instance.limit).to_a
      end

      it 'must prevent preloading when behind threshold' do
        4.times { instance.next }
        instance.instance_variable_get(:@cache).keys.must_equal (0..200).step(instance.limit).to_a
      end

      it 'must preload next set when over threshold' do
        instance.next
        6.times { instance.next }
        instance.instance_variable_get(:@cache).keys.must_equal (0..450).step(instance.limit).to_a
      end
    end
  end
end
