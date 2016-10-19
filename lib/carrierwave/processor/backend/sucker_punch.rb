require 'sucker_punch'
require_relative './base'

require 'sucker_punch/async_syntax' if Gem::Version.new(SuckerPunch::VERSION) >= Gem::Version.new('2.0.0')

module CarrierWave::Processor::Backend
  class SuckerPunch < Base

    class Worker
      include ::SuckerPunch::Job

      def perform uploader_inst, backend
        Thread.current[:uploader] = uploader_inst.class
        uploader_inst.recreate_versions!
        ::SuckerPunch.logger.info "Recreated versions for #{uploader_inst}"
        backend.callbacks.map{|i| i.call(uploader_inst.model)}
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
