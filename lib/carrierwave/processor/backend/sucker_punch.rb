require 'sucker_punch'

module CarrierWave::Processor
  class SuckerPunch < Backend::Base
    class Worker
      include ::SuckerPunch::Job

      def initialize async_id
        @async_id = async_id
        super()
      end

      def perform file
        @async_processing = @async_id
        file.recreate_versions!!
        @async_processing = nil
      end

    end

    def create_worker async_id
      Worker.new(async_id).async
    end
  end
end