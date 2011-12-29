require "spec_helper"
require 'fileutils'

describe Tane::Helpers::Init do

  # TODO: Each test should use mktmp dir instead of running in its own
  # dir, it's dangerous
  before(:each) do
    FileUtils.rm_rf(".bushido")
  end

  it "should include Tane::Helpers" do
    Tane::Helpers::Init.include?(Tane::Helpers).should be_true
  end

  describe ".initialize_app" do
    it "should display initialization message and success message" do
      Tane::Helpers::Init.should_receive(:create_app).and_return({'name'=>'sample'})
      Tane::Helpers::Init.should_receive(:make_app_bushido_dir)
      Tane::Helpers::Init.should_receive(:get_app_envs)
      Tane::Helpers::Init.should_receive(:save_envs)
      Tane::Helpers::Init.should_receive(:save_emails)
      Tane::Helpers::Init.term.should_receive(:say).twice
      
      Tane::Helpers::Init.initialize_app
    end
  end

  describe "update_app" do
    it "should save the environment variables for the app" do
      Tane::Helpers::Init.should_receive(:bushido_envs).
        and_return({'BUSHIDO_NAME' => 'sample_app'})

      Tane::Helpers::Init.should_receive(:get_app_envs)
      Tane::Helpers::Init.should_receive(:save_envs)

      Tane::Helpers::Init.update_app
    end
  end

  describe ".save_envs" do
    it "should write a .bushido/tane.yml file if it does not exist" do
      File.should_receive(:exists?).and_return(false)
      File.should_receive(:open)

      Tane::Helpers::Init.save_envs({})
    end

    it "should write a .bushido/tane.yml file if it already exists and if the user agrees to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      Tane::Helpers::Init.term.should_receive(:agree).and_return(true)
      File.should_receive(:open)

      Tane::Helpers::Init.save_envs({})
    end

    it "should *not* write a .bushido/tane.yml file if the user says no to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      Tane::Helpers::Init.term.should_receive(:agree).and_return(false)
      File.should_not_receive(:open)

      Tane::Helpers::Init.save_envs({})
    end
  end

  describe "save_emails" do
    it "should create a sample email template file to .bushido/emails dir if it does not exist" do
      File.should_receive(:exists?).and_return(false)
      File.should_receive(:open)

      Tane::Helpers::Init.save_emails
    end

    it "should create a sample email template file if it already exists and if the user agrees to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      Tane::Helpers::Init.term.should_receive(:agree).and_return(true)
      File.should_receive(:open)

      Tane::Helpers::Init.save_emails
    end

    it "should not create a sample email template file if the user says no to an overwrite" do
      File.should_receive(:exists?).and_return(true)
      Tane::Helpers::Init.term.should_receive(:agree).and_return(false)
      File.should_not_receive(:open)

      Tane::Helpers::Init.save_emails
    end
  end


  describe "envs_template" do
    it "should return a hash of env variables and their values" do
      Tane::Helpers::Init.envs_template({}).should be_kind_of(Hash)
    end
  end

  describe "example_email_template" do
    it "should return a hash with a sample email template with the name 'example_email_1'" do
      example_email_template = Tane::Helpers::Init.example_email_template

      example_email_template.should be_kind_of(Hash)
      example_email_template['example_email_1'].should_not be_nil
    end
  end

  describe "create_app" do
    before :each do
      @params = {
        :app => {
          :url => "https://github.com/Bushido/tane.git",
          :platform => "developer"
        },
        :authentication_token => "valid_auth_token"
      }
      @bushido_apps_url = "#{Tane::Helpers::Init.bushido_url}/apps.json"
    end
    
    it "should create an app" do
      Tane::Helpers::Init.should_receive(:password).at_least(1).and_return("valid_auth_token")
      RestClient.should_receive(:post).
        with(@bushido_apps_url, @params).
        and_return('{}')
      Tane::Helpers::Init.create_app
    end
  end
end
