require "spec_helper"

describe Tane::Helpers::Cloudfuji do

  describe "cloudfuji_url" do
    it "should return the http://bushid.do by default" do
      # To make sure it's overridden if set in tachi
      ENV['CLOUDFUJI_URL'] = nil
      Tane::Helpers::Cloudfuji.cloudfuji_url.should == "http://cloudfuji.com"
    end

    it "should return the env variable's value if it is set" do
      ENV['CLOUDFUJI_URL'] = "http://noshido.com"
      Tane::Helpers::Cloudfuji.cloudfuji_url.should == "http://noshido.com"
    end
  end
  
  describe ".verify_credentials" do
    before :each do
      @params = {:params => {:email => "email", :password => "password" }}
      @cloudfuji_verify_url = "#{Tane::Helpers::Cloudfuji.cloudfuji_url}/users/verify.json"
    end
    
    it "should return an authentication_token if the verification was a success" do
      result_with_auth_token = {
        :errors => nil,
        :authentication_token => "valid_auth_token"
      }

      RestClient.should_receive(:get).
        with(@cloudfuji_verify_url, @params).and_return(result_with_auth_token.to_json)

      Tane::Helpers::Cloudfuji.verify_credentials("email", "password").should == [result_with_auth_token[:authentication_token] ,nil]
    end

    it "should return false if the verification returned false" do
      result_with_error = {
        :errors => "Sample error",
        :authentication_token => nil
      }

      RestClient.should_receive(:get).
        with(@cloudfuji_verify_url, @params).and_return(result_with_error.to_json)

      Tane::Helpers::Cloudfuji.verify_credentials("email", "password").should == [nil, result_with_error[:errors]]
    end
  end

  describe ".signup" do
    before :each do
      @params = {:params => {:email => "email", :password => "password" }}
      @cloudfuji_create_url = "#{Tane::Helpers::Cloudfuji.cloudfuji_url}/users/create.json"
    end

    it "should signup a user when provided with email and password" do
      result_with_auth_token = {
        :errors => nil,
        :authentication_token => "valid_auth_token"
      }
      
      RestClient.should_receive(:get).
        with(@cloudfuji_create_url, @params).
        and_return(result_with_auth_token.to_json)

      Tane::Helpers::Cloudfuji.signup("email", "password").should == [result_with_auth_token[:authentication_token], nil]
    end

    it "should not signup a user and return errors if any" do
      result_with_error = {
        :errors => "Sample error",
        :authentication_token => nil
      }

      RestClient.should_receive(:get).
        with(@cloudfuji_create_url, @params).and_return(result_with_error.to_json)

      Tane::Helpers::Cloudfuji.signup("email", "password").should == [nil, result_with_error[:errors]]
    end
  end

  describe "authenticate_user" do
    it "should warn the user if credentials already exist" do
      Tane::Helpers::Cloudfuji.should_receive(:warn_if_credentials)
      Tane::Helpers::Cloudfuji.authenticate_user("email", "password")
    end
  end
end
