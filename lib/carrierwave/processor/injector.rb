require 'delegate'

class Injector < SimpleDelegator

  def initialize uploader, options = {}, &block
    super(uploader)
    @outer_version = options.delete(:outer_version)
    @options = options
    self.instance_eval &block
  end

  def process *args, &block
    processed_options = ::CarrierWave::Processor.arguments_merge *args
    unless @outer_version
      new_if = ::CarrierWave::Processor.conditions_merge(@options[:if], processed_options[:if])
      processed_options[:if] = new_if if new_if
    end
    __getobj__.process processed_options, &block
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
    __getobj__.version *version_args do
      Injector.new(self, passing_options, &block)
    end
  end

  def delay *args, &block
  end

end