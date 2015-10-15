module Thron
  class Paginator
    MAX_LIMIT = 50
    PRELOAD_LIMIT = 10
    MAX_PRELOAD = 30

    class PreloadTooLargeError < StandardError; end
    
    attr_reader :total, :offset, :pages

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

    def prev
      call(prev_offset)
    end

    def next
      call(next_offset)
    end

    def to(n)
      call(page_to_offset(n))
    end

    def page
      (@offset / @limit) + 1
    end

    def preload
      self.tap do |instance|
        @preload.times { instance.next }
      end
    end

    def first?
      @offset.zero?
    end

    def last?
      return false unless @total
      (@offset + @limit) >= @total.to_i
    end

    private

    def call(offset = @offset)
      @offset = offset
      @cache.fetch(offset) do
        @body.call(@limit, offset).tap do |response|
          @total ||= response.total
          @pages ||= (@total / @limit.to_f).ceil
          @cache[offset] = response
        end
      end
    end

    def next_offset
      return @offset if (@offset + @limit) >= @total.to_i
      @offset + @limit
    end

    def prev_offset
      return 0 if @offset <= @limit
      @offset - @limit
    end

    def page_to_offset(n)
      n = @pages && n >= @pages ? @pages : n
      (n-1) * @limit
    end
  end
end
