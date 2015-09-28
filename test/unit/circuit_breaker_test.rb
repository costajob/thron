require 'test_helper'
require_relative Thron::root.join('lib', 'thron', 'circuit_breaker')

describe Thron::CircuitBreaker do
  let(:threshold) { 5 }
  let(:circuit_breaker) { Thron::CircuitBreaker::new(threshold: threshold) }

  describe '#initialize' do
    it 'must initialize state' do
      %w[threshold error_count state].each do |attribute|
        assert circuit_breaker.instance_variable_defined?(:"@#{attribute}")
      end
    end

    it 'must start in closed state' do
      refute circuit_breaker.open?
    end
  end

  describe '#monitor' do
    let(:error) { Proc.new { fail 'doh!' } }

    it 'must re-raise the error yielded block' do
      Proc.new { circuit_breaker.monitor(&error) }.must_raise RuntimeError
    end

    it 'must increment error_count at each fail' do
      begin
        circuit_breaker.monitor(&error)
      rescue
        circuit_breaker.instance_variable_get(:@error_count).must_equal 1
      end
    end

    it 'must close the circuit breaker if error count exceeds threshold' do
      circuit_breaker.instance_variable_set(:@error_count, threshold)
      begin 
        circuit_breaker.monitor(&error)
      rescue
        assert circuit_breaker.open?
      end
    end

    it 'must raise an OpenError if circuit breaker is open' do
      circuit_breaker.instance_variable_set(:@state, Thron::CircuitBreaker::OPEN)
      Proc.new { circuit_breaker.monitor(&error) }.must_raise Thron::CircuitBreaker::OpenError
    end

    it 'must reset error count on success' do
      circuit_breaker.instance_variable_set(:@error_count, 2)
      circuit_breaker.monitor do
        :success!
      end
      circuit_breaker.instance_variable_get(:@error_count).must_equal 0
    end

    it 'must return the yielded block result' do
      circuit_breaker.monitor do
        :success!
      end.must_equal :success!
    end
  end
end
