# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'posty_client/version'

Gem::Specification.new do |spec|
  spec.name          = "posty_client"
  spec.version       = PostyClient::VERSION
  spec.authors       = ["Thomas Steinhausen"]
  spec.email         = ["ts@image-addicts.de"]
  spec.description   = %q{A library and a command line tool to use the post api.}
  spec.summary       = %q{Library and cli for the post api.}
  spec.homepage      = "https://github.com/iaddict/posty_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "readwritesettings"
  spec.add_runtime_dependency "activesupport"
end
