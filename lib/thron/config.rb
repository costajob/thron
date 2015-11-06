require 'yaml'
require 'erb'
require 'dotenv'
require 'ostruct'
require 'logger'
require_relative 'root'

module Thron
  module Config
    extend self

    CONFIG_YML = Thron::root.join('config', 'thron.yml')

    def dump_yaml
      Dotenv.load
      @yaml ||= YAML.load(ERB.new(File.read(CONFIG_YML)).result)
    end

    def logger
      @logger ||= begin
                    level   = dump_yaml.fetch('logger').fetch('level')
                    enabled = dump_yaml.fetch('logger').fetch('enabled')
                    OpenStruct.new(enabled: enabled, level: Logger::const_get(level.upcase))
                  end
    end

    def thron
      @thron ||= OpenStruct.new(dump_yaml['thron'])
    end
  end
end
