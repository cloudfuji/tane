require "spec_helper"

describe Tane::Commands::Event do

  describe ".process" do
    it "should post data to the local apps /bushido/data with the event" do
      args = ["Test", "received", "{'foo' => 'bar'}"]
      event = {
        'category' => args.first,
        'event'    => args[1],
        'data'     => eval(args[2])
      }

      Tane::Commands::Event.should_receive(:post).
        with(Tane::Commands::Event.data_url, event)

      Tane::Commands::Event.process(args)
    end
  end
end
