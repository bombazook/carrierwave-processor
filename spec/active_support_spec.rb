require 'spec_helper'
require 'active_support/core_ext/class'

describe "ActiveSupport::Concern" do
  it "prepending module does not break class_attribute" do

    class SomeClass
      prepend Module.new

      def tester
        "instance"
      end

      class_attribute :tester, :instance_reader => false, :instance_writer => false
      self.tester = "class attribute"
    end

    expect(SomeClass.send :singleton_class?).to eq(false)

    expect(SomeClass.new.tester).to eq("instance")
  end

  it "prepending module does not break singleton_class check" do
    class Ana
    end

    Ana.send :prepend, Module.new

    expect(Ana.send :singleton_class?).to eq(false)
  end

end