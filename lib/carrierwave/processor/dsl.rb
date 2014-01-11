module CarrierWave
  module Processor
    module Dsl
      def carrierwave_processor *args, &block
        options = args.extract_options!
        name = args.first
        if name
          if block_given? 
            processor = Node.new(options, &block)
          else
            processor = Node.new(options)
          end
          processor.name = name
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