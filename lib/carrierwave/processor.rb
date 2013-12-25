require 'active_support'
require 'carrierwave'
require "carrierwave/processor/version"
require 'carrierwave/processor/node'
require 'carrierwave/processor/uploader_dsl'

module CarrierWave
  module Processor

    class ProcessorNotFoundError < ::StandardError
    end

    class << self
      attr_accessor :processors
    end

    def self.conditions_merge *args
      args.compact!
      return nil if args.empty?
      return args.first if args.length == 1
      lambda do |uploader, options|
        args.inject(true) do |accum, condition|
          break false unless accum
          condition_result = if condition.respond_to?(:call)
            accum && condition.call(self, options)
          else
            accum && uploader.send(condition, options[:file])
          end
        end
      end
    end

    def self.arguments_merge *args
      args.inject({}) do |hash, arg|
        arg = { arg => [] } unless arg.is_a?(Hash)
        hash.merge!(arg)
      end
    end
  end
end

Object.send :include, CarrierWave::Processor::Dsl
CarrierWave::Uploader::Base.extend CarrierWave::Processor::UploaderDsl