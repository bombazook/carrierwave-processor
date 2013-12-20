# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/processor/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-processor"
  spec.version       = Carrierwave::Processing::VERSION
  spec.authors       = ["Alexander Kostrov"]
  spec.email         = ["bombazook@gmail.com"]
  spec.description   = "Simple dsl cover for carrierwave distinct processing declaration"
  spec.summary       = "carrierwave distinct processing declaration"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
