require "spec_helper"

describe "Tane::Helpers" do

  class Tane::Helpers::Example
    include Tane::Helpers
  end
  
  it "included should extend ClassMethods" do
    Tane::Helpers::Example.respond_to?(:term).should be_true
  end
  
  describe "ClassMethods" do

    describe "term" do
      it "should return a new HighLine instance" do
        Tane::Helpers::Example.term.should be_kind_of(HighLine)
      end
    end

    describe "verbose_say" do
      it "should display the message if the verbose option is true" do
        pending
      end
    end

    describe "bushido_dir" do
      it "should return the path of the user's .bushido directory" do
        pending
      end
    end

    describe "email_template_file_path" do
      it "should return path to current project's .bushido/emails.yml file" do
        pending
      end
    end

    describe "tane_file_path" do
      it "should return path to xsycurrent project's .bushido/tane.yml" do
        pending
      end
    end

    describe "credentials_file_path" do
      it "should return path to user's Bushido credentials file" do
        pending
      end
    end

    describe "logged_in?" do
      it "should return true if the credentials file exists" do
        pending
      end

      it "should return false if the credentials file does not exist" do
        pending
      end
    end

    describe "in_rails_dir?" do
      it "it should return true if the current dir has a rails or script directory" do
        pending
      end
    end

    describe "bushido_app_exists?" do
      it "it should return true if the .bushido dir exists in the current directory" do
        pending
      end
    end

    describe "username" do
      it "should return the username from the credentials" do
        pending
      end
    end

    describe "password" do
      it "should return the password from the credentials" do
        pending
      end
    end

    describe "make_global_bushido_dir" do
      it "should create a .bushido dir in the user's $HOME directory" do
        pending
      end
    end

    describe "make_app_bushido_dir" do
      it "should create a .bushido dir in the current dir if it does not have one" do
        pending
      end

      it "should *not* create a .bushido in the current dir if it already has not" do
        pending
      end
    end

    describe "save_credentials" do
      it "should save the username and the password in the user's bushido_dir" do
      end
    end

    describe "prompt_for_credentials" do
      it "should promt the user for credentials using HighLine" do
        pending
      end

      it "should return an array with email and password" do
        pending
      end
    end

    describe "warn_if_credentials" do
      it "should warn that the user is already logged in" do
        pending
      end
      
      it "should skip if the user says no to reset credentials" do
        pending
      end

      it "should return true if the user says yes to reset credentials" do
        pending
      end
    end

    describe "bushido_envs" do
      it "should return the read the data in .bushido/tane.yml and return a hash" do
        pending
      end
    end

    describe "base_url" do
      it "should return http://localhost:3000 by default if the --host, --scheme and --port options are not set on the command line" do
        pending
      end
    end

    describe "mail_url" do
      it "should return url to local app's Bushido::Mail#index action at/bushido/mail" do
        pending
      end
    end

    describe "post" do
      it "should post to the given url with the given data" do
        # if RestClient is stubbed with should_receive(:post)
        # and added to a before(:each) block then this spec
        # wont be necessary
        pending
      end

      it "should display the result on the terminal if the verbose option is set" do
        pending
      end
      
      it "should return json" do
        pending
      end
    end
  end
    
end
