require 'logger'
require_relative 'config'

module Thron
  extend self

  LOGGER_FILE   = Thron::root.join('log', 'thron.log')
  LOGGER_LEVELS = %i[debug info warn error fatal unknown]

  def logger_level
    LOGGER_LEVELS.fetch(logger.level)
  end

  def logger(file: LOGGER_FILE, level: Config::logger_level)
    @logger ||= Logger.new(file).tap do |logger|
      logger.level = level
    end
  end

  def logger=(logger)
    @logger = logger
  end
end
