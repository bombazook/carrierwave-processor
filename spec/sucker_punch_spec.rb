require 'spec_helper'
require 'carrierwave/processor/backend/sucker_punch'

describe CarrierWave::Processor::Backend::SuckerPunch do
  context 'configure block' do
    it 'sets backend instance if backend chosen' do
      CarrierWave::Processor.configure do |config|
        config.backend :sucker_punch
      end

      CarrierWave::Processor.configuration.backend.should be_kind_of CarrierWave::Processor::Backend::SuckerPunch
    end
  end
  
end