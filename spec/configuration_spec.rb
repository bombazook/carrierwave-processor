require 'spec_helper'


describe CarrierWave::Processor::Configuration do
  subject {CarrierWave::Processor::Configuration.new}
  it 'raises exception when no backend found' do
    expect{subject.backend(:undefined_backend)}.to raise_error(CarrierWave::Processor::BackendNotFound)
  end

  it 'doesnt raise exception when backend found' do
    expect{subject.backend(:base)}.not_to raise_error
  end

  context 'configure block' do
    it 'sets backend instance if backend chosen' do
      CarrierWave::Processor.configure do |config|
        config.backend :base
      end

      CarrierWave::Processor.configuration.backend.should be_kind_of CarrierWave::Processor::Backend::Base
    end
  end


end