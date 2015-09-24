require 'pathname'

module Thron
  extend self

  def root
    @root ||= Pathname.new(File.expand_path(File.join('..', '..', '..'), __FILE__))
  end
end
