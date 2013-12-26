module CarrierWave
  module Processor
    module Dsl
      def carrierwave_processor *args, &block
        options = args.extract_options!
        name = args.first
        if name
          processor = Node.new options
          processor.name = name
          processor.instance_eval &block if block
          if self.kind_of? CarrierWave::Processor::Node
            self.processors ||= {}
            self.processors[name] = processor
          else
            ::CarrierWave::Processor.processors ||= {}
            ::CarrierWave::Processor.processors[name] = processor
          end
          return processor
        end
      end

      def find_carrierwave_processor name
        if self.kind_of? CarrierWave::Processor::Node
          self.processors && self.processors[name.to_sym]
        else
          CarrierWave::Processor.processors && CarrierWave::Processor.processors[name.to_sym]
        end
      end
    end
  end
end