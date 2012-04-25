require "spec_helper"

describe Tane::Commands::Support do

  before :each do
    @message = "user_entered_message"
  end
  
  describe ".process" do
    it "should prompt the user for the message and send it to Cloudfuji" do
      Tane::Commands::Support.term.should_receive(:ask).and_return(@message)
      Tane::Commands::Support.should_receive(:send_message_to_cloudfuji).with(@message)

      Tane::Commands::Support.process([])
    end
  end


  describe ".send_message_to_cloudfuji" do

    before :each do
      Tane::Commands::Support.should_receive(:email_from_credentials_or_prompt).and_return("valid_username")

      RestClient.should_receive(:post).
        with(Tane::Commands::Support.support_url, {
          :source  => "tane",
          :email   => "valid_username",
          :message => @message
        })
    end
    
    it "should display the message being sent" do
      Tane::Commands::Support.term.should_receive(:say).at_least(3)
      Tane::Commands::Support.send_message_to_cloudfuji(@message)
    end

    it "should send a message to Cloudfuji team" do
      Tane::Commands::Support.send_message_to_cloudfuji(@message)
    end

  end
  
  describe ".get_email_or_prompt" do
    it "should return the username if the user is logged in" do
      Tane::Commands::Support.should_receive(:logged_in?).and_return(true)
      Tane::Commands::Support.should_receive(:username).and_return("valid_username")

      Tane::Commands::Support.email_from_credentials_or_prompt.should == "valid_username"
    end

    it "should return the input from prompt if the user is not logged in" do
      Tane::Commands::Support.should_receive(:logged_in?).and_return(false)
      Tane::Commands::Support.term.should_receive(:ask).and_return("valid_username")

      Tane::Commands::Support.email_from_credentials_or_prompt.should == "valid_username"
    end
  end

end
