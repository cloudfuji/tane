require "spec_helper"

describe Tane::Commands::Base do
  it "should include Tane::Helpers" do
    Tane::Commands::Base.include?(Tane::Helpers).should be_true
  end

  describe ".fire" do
    before :each do
      @opts = {:foo => "bar"}
      @args = ["foo", "bar"]
    end

    it "should process the arguments passed" do
      Tane::Commands::Base.should_receive(:process).with(@args)
      Tane::Commands::Base.fire(@opts, @args)
    end

    it "should set the options" do
      Tane::Commands::Base.should_receive(:process).with(@args)
      Tane::Commands::Base.fire(@opts, @args)

      Tane::Commands::Base.instance_variable_get("@opts").should == @opts
    end
  end
end
