# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/processor/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-processor"
  spec.version       = CarrierWave::Processor::VERSION
  spec.authors       = ["Alexander Kostrov"]
  spec.email         = ["bombazook@gmail.com"]
  spec.description   = "Simple dsl cover for carrierwave distinct processing declaration"
  spec.summary       = "Carrierwave distinct processing declaration"
  spec.homepage      = "http://github.com/bombazook/carrierwave-processor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/carrierwave"]
  
  spec.add_dependency 'carrierwave'
  spec.add_dependency 'activesupport', '>= 4.0.4'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_girl"
end
