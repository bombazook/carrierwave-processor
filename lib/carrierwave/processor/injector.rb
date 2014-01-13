require 'delegate'

class Injector < Module
  UNPROXIED_METHODS = %w(__send__ __id__ nil? send object_id extend instance_eval class_eval initialize block_given? raise caller method extend_object)

  (instance_methods + private_instance_methods).each do |method|
    undef_method(method) unless UNPROXIED_METHODS.include?(method.to_s)
  end

  def initialize uploader, opts = {}, &block
    @uploader = uploader
    @outer_version = opts.delete(:outer_version)
    @options = opts
    self.class_eval &block
    @uploader.extend self
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
    version_args = version_options.empty? ? args : (args + [version_options])
    @uploader.version *version_args do
      Injector.new(self, passing_options, &block)
    end
  end

  def method_missing *args, &block
    @uploader.send *args, &block
  end

  def delay *args, &block
  end

end