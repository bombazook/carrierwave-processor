require 'sucker_punch'
require_relative './base'
module CarrierWave::Processor::Backend
  class SuckerPunch < Base

    class Worker
      include ::SuckerPunch::Job

      def perform uploader_inst
        Thread.current[:uploader] = uploader_inst.class
        uploader_inst.recreate_versions!
      end
    end

    def create_worker
      Worker.new.async
    end

    def can_build_uploader? uploader
      return false if Thread.current[:uploader].nil?
      Thread.current[:uploader] == uploader
    end
  end
end
