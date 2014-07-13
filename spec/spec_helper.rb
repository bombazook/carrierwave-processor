require 'rubygems'
require 'bundler/setup'
require 'carrierwave'
require_relative 'utils/raise_matcher'

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'carrierwave/processor'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
