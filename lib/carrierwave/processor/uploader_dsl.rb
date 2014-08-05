require_relative 'dsl'

module CarrierWave
  module Processor
    module UploaderDsl

      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods

        def use_processor *args
          options = args.extract_options!
          args.each do |processor|
            if processor and not ::CarrierWave::Processor.processors.blank? and real_processor = ::CarrierWave::Processor.processors[processor] and real_processor[:block]
              new_if = [options[:if], real_processor[:options][:if]]
              merged_options = real_processor[:options].merge options
              merged_options[:if] = new_if if new_if
              Injector.new(self, merged_options, &real_processor[:block])
            else
              raise ProcessorNotFoundError, processor
            end
          end
        end

        alias_method :use_processors, :use_processor

      end

      def perform_delayed *args
        backend = ::CarrierWave::Processor.configuration.backend
        if !backend.can_build_uploader?(self.class) and backend.uploaders.include? self.class
          ::CarrierWave::Processor.configuration.backend.create_worker.perform(self, backend)
        end
      end

    end
  end
end