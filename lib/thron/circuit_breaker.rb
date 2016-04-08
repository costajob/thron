module Thron
  class CircuitBreaker
    class OpenError < StandardError; end

    %w[open closed].each do |name|
      const_set(name.upcase.to_sym, name.to_sym)
    end

    def initialize(options = {})
      @state = CLOSED
      @threshold = options.fetch(:threshold) { 5 }
      @error_count = 0
      @ignored = options[:ignored].to_a
    end

    def monitor
      return yield if @threshold.zero?
      fail OpenError, 'the circuit breaker is open!' if open?
      result = yield
      handle_success
      result
    rescue OpenError
      raise
    rescue => error
      handle_error(error) unless @ignored.include?(error.class)
      raise
    end

    def open?
      @state == OPEN
    end

    private

    def handle_success
      @error_count = 0
    end

    def handle_error(error)
      @error_count += 1
      if @error_count >= @threshold
        @state = OPEN
      end
    end
  end
end
