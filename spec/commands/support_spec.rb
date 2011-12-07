require "spec_helper"

describe Tane::Commands::Support do

  before :each do
    @message = "user_entered_message"
  end
  
  describe ".process" do
    it "should prompt the user for the message and send it to Bushido" do
      Tane::Commands::Support.term.should_receive(:ask).and_return(@message)
      Tane::Commands::Support.should_receive(:send_message_to_bushido).with(@message)

      Tane::Commands::Support.process([])
    end
  end


  describe ".send_message_to_bushido" do
    it "should display the message sent" do
      Tane::Commands::Support.should_receive(:username).
        and_return("valid_username")
      Tane::Commands::Support.term.should_receive(:say).at_least(1)

      Tane::Commands::Support.send_message_to_bushido(@message)
    end

    it "should send a message to Bushido team" do
      pending "send_message_to_bushido doesn't send emails right now"
    end
  end
end
