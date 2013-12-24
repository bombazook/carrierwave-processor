require 'spec_helper'

describe CarrierWave::Processor::UploaderDsl do
  before :each do
    if Object.constants.include?(:FooUploader)
      Object.send(:remove_const, :FooUploader)
    end
    class FooUploader < CarrierWave::Uploader::Base
    end
  end

  it "CarrierWave Uploader should respond to use_processor" do
    CarrierWave::Uploader::Base.should respond_to :use_processor
    FooUploader.should respond_to :use_processor
  end

  it "calls each of outer processors in processor" do
    carrierwave_processor :some_processor do
      process :resize_to_fit => [800, 800]
      process :something
    end
    FooUploader.should_receive(:process).with(:resize_to_fit => [800, 800])
    FooUploader.should_receive(:process).with(:something => [])
    FooUploader.send(:use_processor, :some_processor)
  end

  it "merges processor condition with use_processor condition" do
    CarrierWave::Processor.stub(:conditions_merge) do |*args|
      args
    end
    combinations = [:method1, ->(u,o){true}].product([:method2, ->u,o{false}])
    combinations.each do |a, b|
      carrierwave_processor :some_processor do
        process :test, :if => a
      end
      FooUploader.should_receive(:process).with(:test => [], :if => CarrierWave::Processor.conditions_merge(b,a))
      FooUploader.send(:use_processor, :some_processor, :if => b)
    end
  end

  it "doesnt raise an exception when version block not given" do
    expect do
      carrierwave_processor :some_processor do
        version :some_version
      end
    end.not_to raise_exception
  end

  it "calls version method for version declaration" do
    carrierwave_processor :some_processor do
      version :some_version
    end
    FooUploader.should_receive(:version)
    FooUploader.send(:use_processor, :some_processor)
  end

  it "calls inner version method with :from_version key" do
    carrierwave_processor :some_processor do
      version :some_version do
        version :another_version
      end
    end

    FooUploader.should_receive(:version).with(:some_version)
    FooUploader.should_receive(:version).with(:another_version, :from_version => :some_version)
    FooUploader.send(:use_processor, :some_processor)
  end

  it "calls inner version processors without if option merge" do
    carrierwave_processor :some_processor do
      version :some_version do
        process :another_version, :if => :abrakadabra
      end
    end
    FooUploader.should_receive(:version).with(:some_version)
  end

end