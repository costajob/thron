require_relative '../behaviour/mappable'

module Thron
  module Entity
    class Image
      def self.mappings
        @mappings ||= { 
          buffer: Attribute::new(name: 'buffer', type: Attribute::LIST),
          crop_area: Attribute::new(name: 'cropArea', type: :Plain),
          mime_type: Attribute::new(name: 'mimeType')
        }
      end

      include Mappable

      def initialize(args = {})
        super
        @path = args.delete(:path)
        return self unless valid_path?
        fetch_mime_type
        fetch_buffer
      end

      private

      def valid_path?
        File.readable?(@path.to_s)
      end

      def fetch_mime_type
        @mime_type ||= `file -b --mime-type #{@path}`.to_s.chomp
      end

      def fetch_buffer
        return @buffer if @buffer && !@buffer.empty?
        @buffer = File.binread(@path).unpack('c*')
      end
    end
  end
end
