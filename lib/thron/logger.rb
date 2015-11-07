require 'logger'
require_relative 'config'

module Thron
  extend self

  LOGGER_FILE   = Thron::root.join('log', 'thron.log')
  LOGGER_LEVELS = %i[debug info warn error fatal unknown]

  NullObj = Struct::new(:file, :level) do
    LOGGER_LEVELS.each do |message|
      define_method(message) do |*args|
        message
      end
    end
  end

  def logger_level
    LOGGER_LEVELS.fetch(logger.level)
  end

  def logger(file: LOGGER_FILE, level: Config::logger::level, enabled: Config::logger::enabled)
    return NullObj::new(file, level) unless enabled
    @logger ||= Logger.new(file).tap do |logger|
      logger.level = level
    end
  end

  def reset_logger(logger = Logger.new(STDOUT))
    @logger = logger
  end
end
