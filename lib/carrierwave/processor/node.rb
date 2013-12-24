require_relative './dsl'

module CarrierWave
  module Processor
    class Node
      include Dsl

      attr_accessor :name, :options
      attr_accessor :processors
      attr_reader :cw_processors

      def initialize opts={}
        @cw_processors = []
        @options = opts
      end

      def process *args, &block
        opts = args.extract_options!
        processor = {:args => args, :block => block}
        @cw_processors << processor
      end

      def background *args, &block
      end

      alias_method :version, :carrierwave_processor

        
    end
  end
end