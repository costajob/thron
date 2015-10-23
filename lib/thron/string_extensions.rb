module Thron
  module StringExtensions
    refine String do
      def snakecase
        partition(/[A-Z]{2,}\Z/).reject(&:empty?).reduce([]) do |acc, token|
          token = token.gsub(/(.)([A-Z])/,'\1_\2').downcase unless token.uppercase?
          acc << token
        end.join('_')
      end

      def camelize_low
        self.split('_').reduce([]) do |acc, token| 
          token.capitalize! unless acc.empty? || token.uppercase?
          acc << token
        end.join
      end

      def uppercase?
        self.upcase == self
      end
    end
  end
end
