require "spec_helper"

describe Tane::Commands::Event do

  subject { Tane::Commands::Event }

  describe ".process" do
    it "should post data to the local apps /cloudfuji/data with the event" do
      args = ["Test", "received", "{'foo' => 'bar'}"]
      event = {
        'category' => args.first,
        'event'    => args[1],
        'data'     => eval(args[2])
      }

      subject.should_receive(:post).
        with(subject.data_url, event)

      subject.process(args)
    end
  end
end
