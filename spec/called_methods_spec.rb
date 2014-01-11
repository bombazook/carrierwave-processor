require 'spec_helper'

describe CarrierWave::Processor::Dsl do

  it 'saves called methods to node' do
    carrierwave_processor :test do
      chachacha "test"
    end

    expect(CarrierWave::Processor.processors[:test].called_methods).to include [:chachacha, "test"]
  end


end