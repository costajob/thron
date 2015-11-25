require 'test_helper'
require 'thron/paginator'

module Mock
  class Gateway
    attr_reader :total, :limit

    def initialize(total = 2000)
      @total = total
      @results = Array::new(total) { |i| { name: "name#{i}", id: (i + 1000) } }
    end

    def find(limit: 50, offset: 0)
      @limit = limit
      OpenStruct::new(total: @total, other_results: (offset * limit < @total), results: @results.slice(offset, limit))
    end
  end
end

describe Thron::Paginator do
  let(:klass) { Thron::Paginator }
  let(:gateway) { Mock::Gateway::new }
  let(:body) { ->(limit, offset) { gateway.find(limit: limit, offset: offset) } }
  let(:instance) { klass::new(body: body) }

  it 'must initialize state' do
    %i[body limit offset cache].each do |attr|
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

  it 'must set the offset' do
    3.times { instance.next }
    instance.prev
    instance.offset.must_equal 50
  end

  it 'must fetch results' do
    instance.next
    instance.next.results.last.must_equal({ name: 'name99', id: 1099 })
    instance.prev.results.first.must_equal({ name: 'name0', id: 1000 })
  end

  it 'must limit previous offset' do
    3.times { instance.prev }
    instance.offset.must_equal 0
    instance.cache.size.must_equal 1
  end

  it 'must limit next offset' do
    50.times { instance.next }
    instance.offset.must_equal 1950
    instance.cache.size.must_equal (gateway.total / gateway.limit)
  end

  it 'must set cache' do
    instance.next
    instance.cache.size.must_equal 1
  end

  it 'must read the cache first' do
    instance.next.equal? instance.prev
  end

  it 'must set total to zero if cache is empty' do
    instance.total.must_equal 0
  end

  it 'must set total when fetching first result' do
    instance.next
    instance.total.must_equal gateway.total
  end

  it 'must preload results' do
    instance.preload(15)
    instance.cache.size.must_equal 15
  end

  it 'must fetch preloaded results' do
    instance.preload(5)
    instance.cache[200].value.results.first.must_equal({ name: 'name200', id: 1200 })
  end

  it 'preload must not move the offset' do
    instance.preload(15)
    instance.offset.must_equal 0
  end

  it 'must preload multiple times' do
    instance.preload(15)
    instance.preload(10)
    instance.cache.size.must_equal 25
  end
end
