module Thron
  module Entity
    class Image < Base
      def initialize(hash = {})
        super
        @path = hash.delete(:path)
        if valid_path?
          fetch_mime_type
          fetch_buffer
        end
      end

      private

      def valid_path?
        File.readable?(@path.to_s)
      end

      def fetch_mime_type
        @table[:mime_type] ||= `file -b --mime-type #{@path}`.to_s.chomp
        new_ostruct_member(:mime_type)
      end

      def fetch_buffer
        @table[:buffer] ||= File.binread(@path).unpack('c*')
        new_ostruct_member(:buffer)
      end
    end
  end
end
