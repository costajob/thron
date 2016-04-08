# coding: utf-8
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'thron/version'

Gem::Specification.new do |s|
  s.name = "thron"
  s.version = Thron::VERSION
  s.authors = ["costajob"]
  s.email = ["costajob@gmail.com"]
  s.summary = %q{Thron APIs ruby client}
  s.homepage = "https://github.com/costajob/thron.git"
  s.license = "MIT"
  s.required_ruby_version = ">= 1.9.1"
  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|s|features)/}) }
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "dotenv", "~> 2.0"
  s.add_runtime_dependency "httparty"
  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rr"
end
