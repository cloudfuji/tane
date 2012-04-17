require "spec_helper"
require 'fileutils'

describe Tane::Helpers::Init do

  subject { Tane::Helpers::Init }
  
  # TODO: Each test should use mktmp dir instead of running in its own
  # dir, it's dangerous
  before(:each) do
    FileUtils.rm_rf(".cloudfuji")
  end

  it "should include Tane::Helpers" do
    subject.include?(Tane::Helpers).should be_true
  end

  describe ".initialize_app" do
    it "should display initialization message and success message" do
      subject.should_receive(:create_app).and_return({'app' => {'name'=>'sample'}})
      subject.should_receive(:make_app_cloudfuji_dir)
      subject.should_receive(:get_app_envs)
      subject.should_receive(:save_envs)
      subject.should_receive(:save_emails)
      subject.term.should_receive(:say).twice
      
      subject.initialize_app
    end
  end

  describe "update_app" do
    it "should save the environment variables for the app" do
      subject.should_receive(:cloudfuji_envs).
        and_return({'CLOUDFUJI_NAME' => 'sample_app'})

      subject.should_receive(:get_app_envs)
      subject.should_receive(:save_envs)

      subject.update_app
    end
  end

  describe ".save_envs" do
    it "should write a .cloudfuji/tane.yml file if it does not exist" do
      File.should_receive(:exists?).and_return(false)
      File.should_receive(:open)

      subject.save_envs({})
    end

    it "should write a .cloudfuji/tane.yml file if it already exists and if the user agrees to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      subject.term.should_receive(:agree).and_return(true)
      File.should_receive(:open)

      subject.save_envs({})
    end

    it "should *not* write a .cloudfuji/tane.yml file if the user says no to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      subject.term.should_receive(:agree).and_return(false)
      File.should_not_receive(:open)

      subject.save_envs({})
    end
  end

  describe "save_emails" do
    it "should create a sample email template file to .cloudfuji/emails dir if it does not exist" do
      File.should_receive(:exists?).and_return(false)
      File.should_receive(:open)

      subject.save_emails
    end

    it "should create a sample email template file if it already exists and if the user agrees to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      subject.term.should_receive(:agree).and_return(true)
      File.should_receive(:open)

      Tane::Helpers::Init.save_emails
    end

    it "should not create a sample email template file if the user says no to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      subject.term.should_receive(:agree).and_return(false)
      File.should_not_receive(:open)

      subject.save_emails
    end
  end


  describe "envs_template" do
    it "should return a hash of env variables and their values" do
      subject.envs_template({}).should be_kind_of(Hash)
    end
  end

  describe "example_email_template" do
    it "should return a hash with a sample email template with the name 'example_email_1'" do
      example_email_template = subject.example_email_template

      example_email_template.should be_kind_of(Hash)
      example_email_template['example_email_1'].should_not be_nil
    end
  end

  describe "create_app" do
    before :each do
      @params = {
        :app => {
          :url => "https://github.com/cloudfuji/tane.git",
          :platform => "developer"
        },
        :authentication_token => "valid_auth_token"
      }
      @cloudfuji_apps_url = "#{subject.cloudfuji_url}/apps.json"
    end
    
    it "should create an app" do
      subject.should_receive(:password).at_least(1).and_return("valid_auth_token")
      RestClient.should_receive(:post).
        with(@cloudfuji_apps_url, @params).
        and_return('{}')
      subject.create_app
    end
  end
end
