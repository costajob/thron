module Thron
  module Parallelizable
    def parallelize(count = 1)
      count.to_i.times.map do |i|
        Thread.new do
          yield(self, i) if block_given?
        end
      end.map(&:value)
    end
  end
end
