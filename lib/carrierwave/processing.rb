require 'active_support'
require "carrierwave/processing/version"

module Carrierwave
  module Processing
    def self.init_local_variable_and_accessors instance, var_name
      class << instance
        attr_reader var_name
      end
      proc_var = instance.instance_variable_get "@#{options[:variable]}"
      if proc_var.nil?
        instance.instance_variable_set("@#{options[:variable]}", []) 
        proc_var = instance.instance_variable_get "@#{options[:variable]}"
      end
    end

    def self.conditions_merge *args
      args.compact!
      return nil if args.empty?
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