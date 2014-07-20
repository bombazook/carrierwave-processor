module CarrierWave::Processor
  module Backend
    class Base
      attr_accessor :options, :delays, :uploaders
      def initialize options={}
        @options = options
      end
      def errback &block
        errbacks << block
      end

      def callback &block
        callbacks << block
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

      def uploaders
        @uploaders ||= []
      end

      def delay uploader, uniq_version_name
        @delays ||= {}
        @delays[uploader] ||= []
        @delays[uploader] << uniq_version_name if uniq_version_name
      end

      def create_worker *args, &block
        raise NotImplementedError.new
      end
    end
  end
end