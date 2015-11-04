# coding: utf-8
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'thron/version'

Gem::Specification.new do |spec|
  spec.name          = "thron"
  spec.version       = Thron::VERSION
  spec.authors       = ["costajob"]
  spec.email         = ["costajob@gmail.com"]

  spec.summary       = %q{Thron APIs ruby client}
  spec.homepage      = "https://github.com/costajob/thron.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dotenv", "~> 2.0"
  spec.add_runtime_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rr"
end
