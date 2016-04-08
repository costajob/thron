require 'logger'
require 'thron/config'

module Thron
  extend self

  LOGGER_FILE   = Thron::root.join('log', 'thron.log')
  LOGGER_LEVELS = %i[debug info warn error fatal unknown]

  def logger_level
    LOGGER_LEVELS.fetch(logger.level)
  end

  def logger(options = {})
    file = options.fetch(:file) { LOGGER_FILE }
    level = options.fetch(:level) { Config::logger::level }
    @logger ||= Logger.new(file).tap do |logger|
      logger.level = level
    end
  end

  def reset_logger(logger = Logger.new(STDOUT))
    @logger = logger
  end
end
