require_relative 'entity'

module Thron
  class Image < Entity
    attr_reader :buffer, :mime_type

    def initialize(hash = {})
      super
      @path = hash.delete(:path)
      return self unless valid_path?
      fetch_mime_type
      fetch_buffer
    end

    private

    def valid_path?
      File.readable?(@path.to_s)
    end

    def fetch_mime_type
      @mime_type = `file -b --mime-type #{@path}`.to_s.chomp
    end

    def fetch_buffer
      @buffer = File.binread(@path).unpack('c*')
    end
  end
end
