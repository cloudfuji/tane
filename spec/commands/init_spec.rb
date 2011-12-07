require "spec_helper"

describe Tane::Commands::Init do

  describe ".process" do
    it "should initialize an app if it's a rails project" do
      Tane::Commands::Init.should_receive(:in_rails_dir?).and_return(true)
      Tane::Helpers::Init.should_receive(:initialize_app)

      Tane::Commands::Init.process([])
    end

    it "should display a message and exit if the current dir isn't a rails project" do
      Tane::Commands::Init.should_receive(:in_rails_dir?).
        and_return(false)

      Tane::Commands::Init.term.should_receive(:say)

      expect {
        Tane::Commands::Init.process([])
      }.to raise_error(SystemExit)
    end
  end

end
