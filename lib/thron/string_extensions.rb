module Thron
  module StringExtensions
    refine String do
      def snakecase
        gsub(/(.)([A-Z])/,'\1_\2').downcase
      end

      def camelize_low
        self.split('_').reduce([]) do |acc, token| 
          token.capitalize! unless acc.empty?
          acc << token
        end.join
      end
    end
  end
end
