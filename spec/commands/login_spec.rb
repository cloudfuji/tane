require "spec_helper"

describe Tane::Commands::Login do

  before :each do
    @valid_email      = "valid_email"
    @valid_password   = "valid_password"
    @valid_auth_token = "valid_auth_token"
  end
  
  describe ".process" do
    it "should save credentials if they are valid" do
      Tane::Commands::Login.
        should_receive(:warn_if_credentials_and_prompt).
        and_return([@valid_email, @valid_password])

      Tane::Commands::Login.should_receive(:verify_or_signup).
        with(@valid_email, @valid_password).
        and_return([@valid_auth_token, nil])

      Tane::Commands::Login.should_receive(:save_credentials)

      Tane::Commands::Login.process([])
    end
  end

  
  describe ".verify_or_signup" do
    it "should return the auth_token if the credentials are valid" do
      Tane::Helpers::Bushido.should_receive(:verify_credentials).
        and_return([@valid_auth_token, nil])
      Tane::Commands::Login.verify_or_signup(@valid_email, @valid_password).should == @valid_auth_token
    end
    
    it "should prompt for signup if the credentials are not valid" do
      Tane::Helpers::Bushido.should_receive(:verify_credentials).
        and_return([nil, "foobar errors"])
      Tane::Commands::Login.should_receive(:signup_and_notify)      
      Tane::Commands::Login.term.should_receive(:agree).and_return(true)
     
      Tane::Commands::Login.verify_or_signup(@valid_email, @valid_password)
    end

    it "should display error messages and exit if user says no to signup" do
      Tane::Helpers::Bushido.should_receive(:verify_credentials).
        and_return([nil, "foobar errors"])
      Tane::Commands::Login.term.should_receive(:agree).and_return(false)

      expect {
        Tane::Commands::Login.verify_or_signup(@valid_email, @valid_password)
      }.to raise_error(SystemExit)
    end
  end


  describe ".display_errors_and_exit" do
    it "should display errors passed to it and exit" do
      errors = [
        ["foo", ["error1", "error2"]],
        ["bar", ["error1", "error2"]]
      ]

      Tane::Commands::Login.term.should_receive(:say).at_least(errors.count)

      expect {
        Tane::Commands::Login.display_errors_and_exit(errors)
      }.to raise_error(SystemExit)
    end
  end


  describe ".display_help_messages_and_exit" do
    it "should display the help messages and exit" do
      Tane::Commands::Login.term.should_receive(:say).at_least(1)

      expect {
        Tane::Commands::Login.display_help_messages_and_exit
      }.to raise_error(SystemExit)
    end
  end
end
