require 'delegate'
require 'active_support/core_ext/class'
module CarrierWave::Processor
  class Injector < Module

   # PLUGIN_OPTIONS = [:outer_version, :root_uploader]

    def initialize uploader, opts = {}, &block
      @uploader = uploader
      @outer_version = opts.delete(:outer_version)
      @root_uploader = opts.delete(:root_uploader) 
      unless @root_uploader
        @root_uploader = @uploader
        unless CarrierWave::Processor.configuration.backend.uploaders.include? @root_uploader
          CarrierWave::Processor.configuration.backend.uploaders << @root_uploader
          @root_uploader.after :store, :perform_delayed
        end
      end
      @options = opts
      self.class_eval &block
      @uploader.send :prepend, self
    end

    def process *args, &block
      processed_options = ::CarrierWave::Processor.arguments_merge *args
      unless @outer_version
        new_if = ::CarrierWave::Processor.conditions_merge(@options[:if], processed_options[:if])
        processed_options[:if] = new_if if new_if
      end
      @uploader.process processed_options, &block
    end

    def version *args, &block
      options = args.extract_options! || {}
      version_options = @options.merge options
      ifs_array = [@options[:if], options[:if]]
      new_if = ::CarrierWave::Processor.conditions_merge *ifs_array
      version_options[:if] = new_if
      version_options.delete :if if version_options[:if].nil?
      version_options[:from_version] = @outer_version if @outer_version
      passing_options = {:if => ifs_array}
      passing_options[:outer_version] = args.first if args.first
      passing_options[:root_uploader] = @root_uploader
      version_args = version_options.empty? ? args : (args + [version_options])
      passing_options[:root_uploader].version *version_args do
        Injector.new(self, passing_options, &block)
      end
    end

    def method_missing *args, &block
      @uploader.send *args, &block
    end

    def delay *args, &block
      options = args.extract_options!
      uniq_version_name = "version_#{SecureRandom.hex}".to_sym
      backend = ::CarrierWave::Processor.configuration.backend
      root_uploader_closure = @root_uploader
      delay_check = ->(uploader, options){ ::CarrierWave::Processor.configuration.backend.can_build_uploader?(root_uploader_closure) }
      backend.delay @uploader, uniq_version_name
      version(uniq_version_name, :if => delay_check, &block)
    end

  end
end