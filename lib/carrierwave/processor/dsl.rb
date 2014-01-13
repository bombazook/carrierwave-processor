module CarrierWave
  module Processor
    module Dsl
      def carrierwave_processor name, options={}, &block
        if name
          ::CarrierWave::Processor.processors ||= {}
          return ::CarrierWave::Processor.processors[name] = {:block => block, :options => options}
        end
        nil
      end
    end
  end
end