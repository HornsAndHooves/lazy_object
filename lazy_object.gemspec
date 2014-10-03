# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_object'

Gem::Specification.new do |spec|
  spec.name          = "lazy_object"
  spec.version       = LazyObject.version
  spec.authors       = ["Arthur Shagall", "Sergey Potapov"]
  spec.email         = ["arthur.shagall@gmail.com"]
  spec.summary       = %q{Lazily initialized object wrapper.}
  spec.description   = %q{It's an object wrapper that forwards all calls to the reference object. This object is not created until the first method dispatch.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
