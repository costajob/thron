module Thron
  class Paginator
    MAX_LIMIT = 50
    PRELOAD_LIMIT = 5
    MAX_PRELOAD = 30

    class PreloadTooLargeError < StandardError; end
    
    attr_reader :total

    def initialize(body:, limit: MAX_LIMIT, offset: 0, preload: PRELOAD_LIMIT)
      fail ArgumentError, 'body must be a proc object' unless body.is_a?(Proc)
      fail ArgumentError, 'body must accept the limit and offset attributes' unless body.arity == 2
      fail PreloadTooLargeError, "preload must be lower than #{MAX_PRELOAD}" if preload > MAX_PRELOAD 
      @body    = body
      @limit   = limit.to_i
      @offset  = offset.to_i
      @preload = preload.to_i
      @cache   = {}
    end

    %i[prev next].each do |name|
      define_method(name) do
        offset = send("#{name}_offset")
        @cache.fetch(offset) do
          @body.call(@limit, offset).tap do |response|
            @offset = offset 
            @total ||= response.total
            @cache[offset] = response
          end
        end
      end
    end

    def preload
      @preload.times { self.next }
    end

    private

    def next_offset
      return max_offset if @offset >= max_offset
      @offset + 1
    end

    def prev_offset
      return 0 if @offset <= 0
      @offset - 1
    end

    def max_offset
      return 1 unless @total
      (@total.to_i / @limit.to_f).ceil
    end
  end
end
