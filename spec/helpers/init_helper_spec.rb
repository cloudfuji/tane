require "spec_helper"

describe Tane::Helpers::Init do

  it "should include Tane::Helpers" do
    Tane::Helpers::Init.include?(Tane::Helpers).should be_true
  end

  describe ".initialize_app" do
    it "should display initialization message" do
      pending
    end

    it "should make a bushido app directory" do
      pending
    end

    it "should save the environment variables and emails" do
      pending
    end

    it "should display a success message after completion" do
      pending
    end
  end

  describe ".save_envs" do
    it "should write a .bushido/tane.yml file if it does not exist" do
      pending
    end

    it "should ask if the .bushido/tane.yml file should be overwritten if it already exists" do
      pending
    end

    it "should write a .bushido/tane.yml file if it already exists and if the user agrees to an overwrite" do
      pending
    end

    it "should not write a .bushido/tane.yml file if the user says no to an overwrite" do
      pending
    end
  end

  describe "save_emails" do
    it "should write a .bushido/emails.yml file if it does not exist" do
      pending
    end

    it "should ask if the .bushido/emails.yml file should be overwritten if it already exists" do
      pending
    end

    it "should write a .bushido/emails.yml file if it already exists and if the user agrees to an overwrite" do
      pending
    end

    it "should not write a .bushido/emails.yml file if the user says no to an overwrite" do
      pending
    end
  end


  describe "envs_template" do
    it "should return a hash of env variables and their values" do
      pending
    end
  end

  describe "emails_template" do
    it "should return a hash with a sample email template with the name 'example_email_1'" do
      pending
    end
  end
end
