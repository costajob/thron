require 'test_helper'
require Thron.root.join('lib', 'thron', 'behaviour', 'parallelizable')

module Mock
  class Numeric
    include Thron::Parallelizable

    def initialize(n)
      @n = n
    end

    def power_of(of)
      @n**(of.to_i)
    end
  end
end

describe Thron::Parallelizable do
  let(:parallelizable) { Mock::Numeric::new(3) }
  let(:values) { parallelizable.parallelize(10) { |instance, i| instance.power_of(i) } }

  it 'must collect results in an array' do
    values.must_be_instance_of Array
  end

  it 'must collect one result per thread' do
    values.size.must_equal 10
  end

  it 'must properly execute the block' do
    values.sort.last.must_equal 3**9
  end
end
