require 'thron/version'
require 'thron/root'
Dir[Thron::root.join('lib', 'thron', 'gateway', '*.rb')].each { |f| require f }
