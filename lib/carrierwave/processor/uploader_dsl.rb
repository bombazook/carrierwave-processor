require_relative 'dsl'

module CarrierWave
  module Processor
    module UploaderDsl

      def use_processor *args
        options = args.extract_options!
        args.each do |processor|
          if processor and processor = ::CarrierWave::Processor.processors.try(:[], processor) and processor[:block]
            new_if = [options[:if], processor[:options][:if]]
            merged_options = processor[:options].merge options
            merged_options[:if] = new_if if new_if
            Injector.new(self, merged_options, &processor[:block])
          else
            raise ProcessorNotFoundError, processor
          end
        end
      end

      alias_method :use_processors, :use_processor

    end
  end
end