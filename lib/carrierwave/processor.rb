require 'active_support'
require 'carrierwave'
require "carrierwave/processor/version"
require "carrierwave/processor/injector"
require 'carrierwave/processor/uploader_dsl'
require 'carrierwave/processor/configuration'
require 'pathname'

module CarrierWave
  module Processor
    def self.root
      Pathname.new(File.expand_path '../..', __FILE__)
    end

    class ProcessorNotFoundError < ::StandardError
    end

    class << self
      attr_accessor :processors
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure options={}, &block
      c = configuration
      options.each do |k, v|
        c.send "#{k}=", v
      end
      yield c
    end

    def self.async_processing? async_id
      false
    end

    def self.conditions_merge *args
      args.flatten!
      args.compact!
      return nil if args.empty?
      return args.first if args.length == 1
      self.merge_multiple_conditions *args
    end

    def self.merge_multiple_conditions *args
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
CarrierWave::Uploader::Base.include CarrierWave::Processor::UploaderDsl