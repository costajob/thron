require 'yaml'
require 'erb'
require 'dotenv'
require 'ostruct'
require 'uri'
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

    def cache
      return @cache if @cache
      redis_url = URI(dump_yaml['cache'].delete('redis_url'))
      @cache = OpenStruct.new(dump_yaml['cache'].merge(redis_url: redis_url))
    end

    def logger_level
      level = dump_yaml.fetch('logger').fetch('level')
      Logger::const_get(level.upcase)
    end

    def thron
      @thron ||= OpenStruct.new(dump_yaml['thron'])
    end
  end
end