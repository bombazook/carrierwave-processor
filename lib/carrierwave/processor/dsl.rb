require_relative 'processor'

module Carrierwave
  module Processing
    module Dsl
      def carrierwave_processor *args, &block
        options = args.extract_options!
        options[:variable] ||= :processors
        name = args.first
        if name
          processor = ::Carrierwave::Processing::Processor.new options
          processor.name = name
          processor.instance_eval &block
          proc_var = ::Carrierwave::Processing.init_local_variable_and_accessors(self, options[:variable])
          proc_var << processor
          return processor
        end
      end
    end
  end
end