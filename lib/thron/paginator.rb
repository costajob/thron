require 'ostruct'
require 'thron/response'

module Thron
  class Paginator
    MAX_LIMIT = 50

    def self.check_limit(limit)
      limit.to_i.tap do |limit|
        return MAX_LIMIT if limit > MAX_LIMIT
      end
    end
    
    attr_reader :offset, :limit, :cache

    def initialize(body:, limit: MAX_LIMIT)
      fail ArgumentError, 'body must be a proc object' unless body.is_a?(Proc)
      fail ArgumentError, 'body must accept the limit and offset attributes' unless body.arity == 2
      @body    = body
      @limit   = self.class.check_limit(limit)
      @offset  = offset.to_i
      @cache   = {}
    end

    def prev
      @offset = prev_offset
      fetch.value
    end

    def next
      @offset = next_offset
      fetch.value
    end

    def preload(n)
      starting_offset = max_offset
      (n).to_i.times do |i|
        index  = starting_offset.zero? ? i : (i + 1)
        offset = starting_offset + (index * @limit)
        fetch(offset)
      end
    end

    def total
      return @total if @total
      return 0 if cache.empty?
      @total = cache.fetch(0).value.total
    end

    private

    def fetch(offset = @offset)
      @cache.fetch(offset) do
        call(offset).tap do |raw|
          @cache[offset] = raw
        end
      end
    end

    def call(offset)
      Thread::new { @body.call(@limit, offset) }
    end

    def next_offset
      return 0 if cache.empty?
      return @offset if total > 0 && (@offset + @limit) >= total
      @offset + @limit
    end

    def prev_offset
      return 0 if @offset <= @limit
      @offset - @limit
    end

    def max_offset
      return 0 if cache.empty?
      @cache.max.first
    end
  end
end
