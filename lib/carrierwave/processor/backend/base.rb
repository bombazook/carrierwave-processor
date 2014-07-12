module CarrierWave::Processor
  module Backend
    class Base
      attr_accessor :options
      def initialize options={}
        @options = options
      end
      def errback &block
        @errbacks << block
      end

      def callback &block
        @callbacks << block
      end

      def callbacks
        @callbacks ||= []
      end

      def errbacks
        @callbacks ||= []
      end

      def stub &block
        @stub = block
      end

      def stub_cache &block
        @stub_cache = block
      end

      def create_worker *args, &block
        raise NotImplementedError.new
      end
    end
  end
end