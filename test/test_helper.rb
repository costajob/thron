require 'minitest/autorun'
require 'rr'
require 'ostruct'
require 'tempfile'
require_relative '../lib/thron/config'

Thron::Config::debug.routing = false
