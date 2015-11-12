module Thron
  class Paginator
    MAX_LIMIT = 50
    MAX_PRELOAD = 30
    INITIAL_LOAD_MISSING = :initial_load_missing

    class PreloadTooLargeError < StandardError; end

    def self.check_limit(limit)
      limit.to_i.tap do |limit|
        return MAX_LIMIT if limit > MAX_LIMIT
      end
    end
    
    attr_reader :total, :offset, :pages, :limit

    def initialize(body:, limit: MAX_LIMIT, preload: 0)
      fail ArgumentError, 'body must be a proc object' unless body.is_a?(Proc)
      fail ArgumentError, 'body must accept the limit and offset attributes' unless body.arity == 2
      fail PreloadTooLargeError, "preload must be lower than #{MAX_PRELOAD}" if preload > MAX_PRELOAD 
      @body    = body
      @limit   = self.class.check_limit(limit)
      @offset  = offset.to_i
      @preload = preload.to_i
      @cache   = {}
    end

    def prev
      @offset = prev_offset
      call
    end

    def next
      preload!
      @offset = next_offset
      call
    end

    def to(n)
      return INITIAL_LOAD_MISSING unless @pages
      @offset = page_to_offset(n)
      call
    end

    def page
      (@offset / @limit) + 1
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
      @cache.fetch(offset) do
        @body.call(@limit, offset).tap do |response|
          @total ||= response.total.to_i
          @other_results = response.other_results
          @pages ||= fetch_pages
          @cache[offset] = response
        end
      end
    end

    def fetch_pages
      return if @other_results
      return 1 if @total.zero?
      (@total / @limit.to_f).ceil
    end

    def preload?
      @offset == last_cached 
    end

    def preload!
      @preload.times do |i|
        index  = @offset.zero? ? i : i+1
        break if stop_preloading?(index)
        offset = @offset + index * @limit
        call(offset)
      end if preload?
    end

    def stop_preloading?(index)
      !@other_results && @total && @total <= index * @limit
    end

    def last_cached
      @cache.keys.max.to_i
    end

    def next_offset
      (@offset + @limit).tap do |offset|
        return offset if @other_results
        return @offset if (@offset + @limit) >= @total.to_i
      end
    end

    def prev_offset
      return 0 if @offset <= @limit
      @offset - @limit
    end

    def page_to_offset(n)
      n = n >= @pages ? @pages : n
      (n-1) * @limit
    end
  end
end
