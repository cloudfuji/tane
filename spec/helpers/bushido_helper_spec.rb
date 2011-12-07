require "spec_helper"

describe Tane::Helpers::Bushido do

  describe "bushido_url" do
    it "should return the http://bushid.do by default" do
      # To make sure it's overridden if set in tachi
      ENV['BUSHIDO_URL'] = nil
      Tane::Helpers::Bushido.bushido_url.should == "http://bushi.do"
    end

    it "should return the env variable's value if it is set" do
      ENV['BUSHIDO_URL'] = "http://noshido.com"
      Tane::Helpers::Bushido.bushido_url.should == "http://noshido.com"
    end
  end
  
  describe ".verify_credentials" do
    before :each do
      @params = {:params => {:email => "email", :password => "password" }}
      @bushido_verify_url = "#{Tane::Helpers::Bushido.bushido_url}/users/verify.json"
    end
    
    it "should return an authentication_token if the verification was a success" do
      result_with_auth_token = {
        :errors => nil,
        :authentication_token => "valid_auth_token"
      }

      RestClient.should_receive(:get).
        with(@bushido_verify_url, @params).and_return(result_with_auth_token.to_json)

      Tane::Helpers::Bushido.verify_credentials("email", "password").should == [result_with_auth_token[:authentication_token] ,nil]
    end

    it "should return false if the verification returned false" do
      result_with_error = {
        :errors => "Sample error",
        :authentication_token => nil
      }

      RestClient.should_receive(:get).
        with(@bushido_verify_url, @params).and_return(result_with_error.to_json)

      Tane::Helpers::Bushido.verify_credentials("email", "password").should == [nil, result_with_error[:errors]]
    end
  end

  describe ".signup" do
    before :each do
      @params = {:params => {:email => "email", :password => "password" }}
      @bushido_create_url = "#{Tane::Helpers::Bushido.bushido_url}/users/create.json"
    end

    it "should signup a user when provided with email and password" do
      result_with_auth_token = {
        :errors => nil,
        :authentication_token => "valid_auth_token"
      }
      
      RestClient.should_receive(:get).
        with(@bushido_create_url, @params).
        and_return(result_with_auth_token.to_json)

      Tane::Helpers::Bushido.signup("email", "password").should == [result_with_auth_token[:authentication_token], nil]
    end

    it "should not signup a user and return errors if any" do
      result_with_error = {
        :errors => "Sample error",
        :authentication_token => nil
      }

      RestClient.should_receive(:get).
        with(@bushido_create_url, @params).and_return(result_with_error.to_json)

      Tane::Helpers::Bushido.signup("email", "password").should == [nil, result_with_error[:errors]]
    end
  end

  describe "authenticate_user" do
    it "should warn the user if credentials already exist" do
      Tane::Helpers::Bushido.should_receive(:warn_if_credentials)
      Tane::Helpers::Bushido.authenticate_user("email", "password")
    end
  end
end
