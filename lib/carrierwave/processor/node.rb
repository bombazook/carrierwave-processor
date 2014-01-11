require_relative './dsl'

module CarrierWave
  module Processor
    class Node < Module
      include Dsl

      attr_accessor :name, :options
      attr_accessor :processors, :uploader_methods, :called_methods
      attr_reader :cw_processors

      def initialize opts={}, &block
        @cw_processors = []
        @uploader_methods = []
        @called_methods = []
        @processors = {}
        @options = opts
        super(&block)
      end

      def process *args, &block
        processor = {:args => args, :block => block}
        @cw_processors << processor
      end

      def background *args, &block
      end

      def method_missing *args, &block
        meth = [*args]
        meth << block if block_given?
        @called_methods << meth
      end

      alias_method :version, :carrierwave_processor

        
    end
  end
end