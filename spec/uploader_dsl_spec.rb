require 'spec_helper'

describe CarrierWave::Processor::UploaderDsl do
  it "CarrierWave Uploader should respond to use_processor" do
    CarrierWave::Uploader::Base.should respond_to :use_processor
  end
end