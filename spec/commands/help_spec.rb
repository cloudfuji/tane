require "spec_helper"

describe Tane::Commands::Help do

  describe ".process" do
    it "should display the OptParse's help section's banner" do
      Tane::Commands::Help.opts.should_receive(:banner)
      Tane::Commands::Help.process([])
    end
  end

end
