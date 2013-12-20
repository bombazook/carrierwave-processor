require_relative 'dsl'

module Carrierwave
  module Processing
    module UploaderDsl

      def use_processor *args
        options = args.extract_options!
        conditions = options.delete(:conditions) || [options[:if]]
        processor = args.first

        load_cw_processors processor, :conditions => conditions
        load_cw_versions processor, :conditions => conditions
      end

      private

        def load_cw_processors processor, options = {}
          conditions = options[:conditions] || []
          processor.cw_processors.each do |cw_processor|
            new_processors = :Carrierwave::Processing.arguments_merge cw_processor[:args]
            new_conditions = conditions + [new_processors[:if]]
            new_processors[:if] = ::Carrierwave::Processing.conditions_merge(*new_conditions)
            process new_processors
          end
        end

        def load_cw_versions processor, options = {}
          conditions = options[:conditions] || []
          processor.processors.each do |version|
            new_conditions = conditions + [version.options[:if]]
            condition = ::Carrierwave::Processing.conditions_merge(*new_conditions)
            version_options = version.options
            version_options.merge! options if options
            version_options.merge!(:if => condition) if condition
            version version.name, version_options do
              load_cw_processors version
            end
            load_cw_versions :conditions => :new_conditions, :from_version => version.name
          end
        end
    end
  end
end