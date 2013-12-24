require 'spec_helper'

describe CarrierWave::Processor::Dsl do

  before :each do
    ::CarrierWave::Processor.processors = {}
  end

  it "returns processor node on carrierwave_processor call" do
    processor = carrierwave_processor(:some_processor){}
    processor.should be_kind_of CarrierWave::Processor::Node
  end

  it "stores processor to centralized hash storage" do
    carrierwave_processor(:another_processor){}
    ::CarrierWave::Processor.processors.should have_key :another_processor
  end

  it "saves new processor to storage if same key given" do
    first_processor = carrierwave_processor(:processor){}
    ::CarrierWave::Processor.processors[:processor].should be_equal first_processor
    second_processor = carrierwave_processor(:processor){}
    ::CarrierWave::Processor.processors[:processor].should_not be_equal first_processor
    ::CarrierWave::Processor.processors[:processor].should be_equal second_processor
  end

  it "does not save inner processor to global storage but save it to local storage" do
    outer_processor = carrierwave_processor(:processor) do
      carrierwave_processor(:another_processor){}
    end
    ::CarrierWave::Processor.processors.should_not have_key :another_processor
  end

  it "saves carrierwave processor arguments to cw_processors" do
    processor = carrierwave_processor :some do
      process :nya
    end
    processor.cw_processors.first.should == {:args => [:nya], :block => nil}
  end

  
end