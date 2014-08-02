require 'carrierwave/processor/backend/base'
module CarrierWave::Processor

  class BackendNotInitializedError < StandardError
    def initialize msg="set up backend first"
      super
    end
  end

  class BackendNotFound < StandardError
    def initialize name
      super("backend with name #{name.to_s.classify} not found")
    end
  end

  class Configuration
    delegate :callback, :errback, :stub, :stub_cache, :to => :backend

    attr_writer :backend

    def delay
      self
    end

    def backend_configured?
      @backend.present?
    end

    def backend name=nil, options={}
      if name
        backends_path = (::CarrierWave::Processor.root + 'carrierwave/processor/backend')
        backend_file = backends_path.entries.detect{|i| i.basename('.rb').to_s == name.to_s}
        raise BackendNotFound.new(name) unless backend_file
        backend_file = backends_path + backend_file
        require backend_file
        raise BackendNotFound.new(name) unless backend_file
        begin
          klass = ::CarrierWave::Processor::Backend.const_get(name.to_s.classify.to_sym)
        rescue NameError
          raise BackendNotFound.new(name)
        end
        options = @backend.options.merge(options) if @backend
        @backend = klass.new options
      elsif @backend
        @backend
      else
        raise BackendNotInitializedError.new
      end
    end

  end
end