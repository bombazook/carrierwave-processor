require 'spec_helper'

describe 'Injector#delay' do

  before :all do
    carrierwave_processor :delay_processor do
      delay do
        process :test
      end
    end
  end

  before :each do
    if Object.constants.include?(:FooUploader)
      Object.send(:remove_const, :FooUploader)
    end
    class FooUploader < CarrierWave::Uploader::Base
      version :alalas do
        def chacha
        end
      end

      def test_me
        "original"
      end
    end
    CarrierWave::Processor.configuration = nil

  end

  it 'raise error on #delay if no backend chosen' do
    expect{FooUploader.send(:use_processor, :delay_processor)}.to raise_error(CarrierWave::Processor::BackendNotInitializedError)
  end

  it 'doesnt raise BackendNotInitializedError error if backend chosen' do
    CarrierWave::Processor.configure do |config|
      config.backend :base
    end
    begin
      expect(FooUploader.send(:use_processor, :delay_processor)).to never_raise(CarrierWave::Processor::BackendNotInitializedError)
    rescue NotImplementedError
      # can raise NotImplemented
    end
  end

end