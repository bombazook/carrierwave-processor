require 'spec_helper'

describe CarrierWave::Processor::UploaderDsl do
  before :each do 
    CarrierWave::Processor.stub(:merge_multiple_conditions) do |*args|
      args
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
        version :another_version do
        end
      end
    end

    FooUploader.should_receive(:version).with(:some_version).and_call_original
    FooUploader.should_receive(:version).with(:another_version, :from_version => :some_version)
    FooUploader.send(:use_processor, :some_processor)
  end

  it "calls inner version processors without if option merge" do
    carrierwave_processor :some_processor do
      version :some_version, :if => :nyasha do
        process :processing, :if => :abrakadabra
      end
    end
    FooUploader.should_receive(:process).with(:processing => [], :if => :abrakadabra)
    FooUploader.send(:use_processor, :some_processor, :if => :kuku)
  end

  it 'multiple versions merges correctly' do
    
    carrierwave_processor :some_processor do
      process :root_process, :if => :e
      process :root2_process
      version :a2_version do
        process :a3_process
        process :a4_process, :if => :a4
      end
      version :a_version, :if => :b do
        process :a_process, :if => :f
        process :a2_process
        version :b_version do
          process :b_process, :if => :e
          process :b2_process
          version :c_version, :if => :c do
            process :c_process, :if => :d
            process :c2_process
            version :d_version do
              process :d_process, :if => :e
              process :d2_process
            end
          end
        end
      end
    end

    FooUploader.should_receive(:version).with(:a2_version, :if => :root).and_call_original
    FooUploader.should_receive(:version).with(:a_version, :if => [:root, :b]).and_call_original
    FooUploader.should_receive(:version).with(:b_version, :from_version => :a_version, :if => [:root, :b]).and_call_original
    FooUploader.should_receive(:version).with(:c_version, :from_version => :b_version, :if => [:root, :b, :c]).and_call_original
    FooUploader.should_receive(:version).with(:d_version, :from_version => :c_version, :if => [:root, :b, :c]).and_call_original

    FooUploader.should_receive(:process).with(:root_process => [], :if => [:root, :e])
    FooUploader.should_receive(:process).with(:root2_process => [], :if => :root)
    FooUploader.should_receive(:process).with(:a3_process => [])
    FooUploader.should_receive(:process).with(:a4_process => [], :if => :a4)
    FooUploader.should_receive(:process).with(:a_process => [], :if => :f)
    FooUploader.should_receive(:process).with(:a2_process => [])
    FooUploader.should_receive(:process).with(:b_process => [], :if => :e)
    FooUploader.should_receive(:process).with(:b2_process => [])
    FooUploader.should_receive(:process).with(:c_process => [], :if => :d)
    FooUploader.should_receive(:process).with(:c2_process => [])
    FooUploader.should_receive(:process).with(:d_process => [], :if => :e)
    FooUploader.should_receive(:process).with(:d2_process => [])

    FooUploader.send(:use_processor, :some_processor, :if => :root)
  end

  it "doesnt raise NoMethodError when no processor declared" do
    CarrierWave::Processor.processors = nil
    expect {FooUploader.send(:use_processor, :some_processor) }.to raise_error(CarrierWave::Processor::ProcessorNotFoundError)
  end

  it "includes declared methods in each version" do
    carrierwave_processor :some_proc do
      def some_method
      end

      version :test do
        def some_method2
        end
      end
    end

    FooUploader.send(:use_processor, :some_proc)
    FooUploader.new.should respond_to :some_method
    FooUploader.new.should_not respond_to :some_method2
    FooUploader.versions[:test][:uploader].new.should respond_to :some_method2
  end

  it 'redefine default methods' do

    carrierwave_processor :some_proc do
      def test_me
        "overriden"
      end

      version :test do
        def test_me
          "overriden internal"
        end
      end
    end

    FooUploader.send(:use_processor, :some_proc)
    FooUploader.new.test_me.should == "overriden"
    FooUploader.versions[:test][:uploader].new.test_me.should == "overriden internal"
  end

  it "doesnt include injector's method_missing into uploader" do
     carrierwave_processor :some_proc do
      def test_me
        "overriden"
      end

      version :test do
        def test_me
          "overriden internal"
        end
      end
    end

    FooUploader.send(:use_processor, :some_proc)
    FooUploader.new.should_not respond_to :method_missing
    FooUploader.versions[:test][:uploader].new.should_not respond_to :method_missing
  end

  it "doesnt break carrrierwave uploader instance versions" do
    carrierwave_processor :some_proc do
      def test_me
        "overriden"
      end

      version :test do
        def test_me
          "overriden internal"
        end
      end
    end
    FooUploader.send(:use_processor, :some_proc)
    FooUploader.new.versions.map{|name, uploader| uploader.should be_kind_of FooUploader}
  end

  it 'run block into delay with adding if to options' do
    CarrierWave::Processor::Backend::Base.any_instance.stub(:create_worker).and_return nil
    CarrierWave::Processor.configure do |config|
      config.backend :base
    end
    carrierwave_processor :some_proc do
      version :some_version do
        process :inner_processing
      end
      delay do
        process :processing
      end
    end

    FooUploader.should_receive(:version).with(:some_version).and_call_original
    FooUploader.should_receive(:version).and_call_original
    FooUploader.should_receive(:process).with(:inner_processing => [])
    FooUploader.should_receive(:process).with(hash_including(:processing))
    FooUploader.send(:use_processor, :some_proc)
  end


end