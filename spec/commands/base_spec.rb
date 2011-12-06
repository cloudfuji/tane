require "spec_helper"

describe Tane::Commands::Base do
  it "should include Tane::Helpers" do
    Tane::Commands::Base.include?(Tane::Helpers).should be_true
  end

  describe ".fire" do
    it "should process the arguments passed" do
      pending
    end

    it "should set the options" do
      pending
    end
  end
end
