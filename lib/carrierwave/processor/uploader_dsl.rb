require_relative 'dsl'

module CarrierWave
  module Processor
    module UploaderDsl

      def use_processor *args
        options = args.extract_options!
        conditions = [options.delete(:conditions) || options[:if]].flatten.compact
        args.each do |processor|
          passing_in_options = {}
          passing_in_options.merge!(:conditions => conditions) unless conditions.empty?
          if processor and processor = find_carrierwave_processor(processor)
            load_cw_processors processor, passing_in_options
            load_cw_versions processor, passing_in_options
          else
            raise ProcessorNotFoundError, processor
          end
        end
      end

      private

        def load_cw_processors processor, options = {}
          conditions = options[:conditions] || []
          processor.cw_processors.each do |cw_processor|
            new_processors = ::CarrierWave::Processor.arguments_merge *cw_processor[:args]
            new_conditions = (conditions + [new_processors[:if]]).compact
            new_processors[:if] = ::CarrierWave::Processor.conditions_merge(*new_conditions) unless new_conditions.empty?
            process new_processors
          end
        end

        def load_cw_versions processor, options = {}
          conditions = options[:conditions] || []
          processor.processors.each do |name, version|
            new_conditions = (conditions + [version.options[:if]]).compact
            condition = ::CarrierWave::Processor.conditions_merge(*new_conditions) unless new_conditions.empty?
            version_options = version.options
            version_options.merge! options if options
            version_options.merge!(:if => condition) if condition
            if version_options.empty?
              version name do
                load_cw_processors version
              end
            else
              version name, version_options do
                load_cw_processors version
              end
            end
            next_level_options = {:from_version => version.name}
            next_level_options.merge!(:conditions => new_conditions) unless conditions.empty?
            load_cw_versions version, next_level_options
          end
        end
    end
  end
end