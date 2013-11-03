# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kapost/version'

Gem::Specification.new do |spec|
  spec.name          = "kapost"
  spec.version       = Kapost::VERSION
  spec.authors       = ["Brian Laska"]
  spec.email         = ["brian@laska.us"]
  spec.description   = %q{Kapost API Wrapper}
  spec.summary       = %q{Simple Ruby wrapper for the Kapost API version 1}
  spec.homepage      = "https://github.com/blaska/kapost"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"

  spec.add_dependency "rest-client", "~> 1.6.7"
  spec.add_dependency "json"
end
