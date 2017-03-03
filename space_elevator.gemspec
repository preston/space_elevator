# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'space_elevator/version'

Gem::Specification.new do |spec|
  spec.name          = "space_elevator"
  spec.version       = SpaceElevator::VERSION
  spec.authors       = ["Preston Lee"]
  spec.email         = ["preston.lee@prestonlee.com"]

  spec.summary       = %q{Ruby client for integrating a ruby application with a remote ActionCable-based backend provided by Rails 5 or compatible framework.}
  spec.description   = %q{Ruby client for integrating a ruby application with a remote ActionCable-based backend provided by Rails 5 or compatible framework. It allows for subscription and publication to multiple _channels_ simultaneously, and eavesdropping on wire-level messages. Harness the power of WebSockets to receive push notifications in your own Ruby applications!}
  spec.homepage      = "https://github.com/preston/space_elevator"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "eventmachine", ">= 1.2.3"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
