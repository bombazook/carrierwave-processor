module Carrierwave
  module Processing
    class Processor
      include DSL

      attr_accessor :name, :options
      attr_reader :cw_processors

      def initialize opts={}
        @cw_processors = []
        @options = opts
      end

      def process *args, &block
        opts = args.extract_options!
        processor = {:args => args, :block => block}.with_indifferent_access!
        @cw_processors << processor
      end

      def background *args, &block
      end

      alias_method :carrierwave_processor, :version

        
    end
  end
end