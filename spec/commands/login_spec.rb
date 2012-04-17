require "spec_helper"

describe Tane::Commands::Login do

  subject { Tane::Commands::Login }

  before :each do
    @valid_email      = "valid_email"
    @valid_password   = "valid_password"
    @valid_auth_token = "valid_auth_token"
  end
  
  describe ".process" do
    it "should save credentials if they are valid" do
      subject.
        should_receive(:warn_if_credentials_and_prompt).
        and_return([@valid_email, @valid_password])

      subject.should_receive(:verify_or_signup).
        with(@valid_email, @valid_password).
        and_return([@valid_auth_token, nil])

      subject.should_receive(:save_credentials)

      subject.process([])
    end
  end

  
  describe ".verify_or_signup" do
    it "should return the auth_token if the credentials are valid" do
      Tane::Helpers::Cloudfuji.should_receive(:verify_credentials).
        and_return([@valid_auth_token, nil])
      subject.verify_or_signup(@valid_email, @valid_password).should == @valid_auth_token
    end
    
    it "should prompt for signup if the credentials are not valid" do
      Tane::Helpers::Cloudfuji.should_receive(:verify_credentials).
        and_return([nil, "foobar errors"])
      subject.should_receive(:signup_and_notify)      
      subject.term.should_receive(:agree).and_return(true)
     
      subject.verify_or_signup(@valid_email, @valid_password)
    end

    it "should display error messages and exit if user says no to signup" do
      Tane::Helpers::Cloudfuji.should_receive(:verify_credentials).
        and_return([nil, "foobar errors"])
      subject.term.should_receive(:agree).and_return(false)

      expect {
        subject.verify_or_signup(@valid_email, @valid_password)
      }.to raise_error(SystemExit)
    end
  end


  describe ".display_errors_and_exit" do
    it "should display errors passed to it and exit" do
      errors = [
        ["foo", ["error1", "error2"]],
        ["bar", ["error1", "error2"]]
      ]

      subject.term.should_receive(:say).at_least(errors.count)

      expect {
        subject.display_errors_and_exit(errors)
      }.to raise_error(SystemExit)
    end
  end


  describe ".display_help_messages_and_exit" do
    it "should display the help messages and exit" do
      subject.term.should_receive(:say).at_least(1)

      expect {
        subject.display_help_messages_and_exit
      }.to raise_error(SystemExit)
    end
  end
end
