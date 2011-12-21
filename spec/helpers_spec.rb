require "spec_helper"

describe "Tane::Helpers" do

  class Tane::Helpers::Example
    include Tane::Helpers
  end
  
  it "included should extend ClassMethods" do
    Tane::Helpers::Example.include?(Tane::Helpers).should be_true
  end
  
  describe "ClassMethods" do

    describe "term" do
      it "should return a new HighLine instance" do
        Tane::Helpers::Example.term.should be_kind_of(HighLine)
      end
    end

    describe "verbose_say" do
      it "should display the message if the verbose option is true" do
        Tane::Helpers::Example.opts.verbose = true
        Tane::Helpers::Example.term.should_receive(:say)
        Tane::Helpers::Example.verbose_say("detailed message")
      end
    end

    describe "bushido_dir" do
      it "should return the path of the user's .bushido directory" do
        Tane::Helpers::Example.bushido_dir.should == "#{ENV['HOME']}/.bushido"
      end
    end

    describe "email_templates_path" do
      it "should return path to the template file in the project's .bushido dir" do
        Tane::Helpers::Example.email_templates_path.should == ".bushido/emails"
      end
    end
    
    describe "email_template_file_path" do
      it "should return path to the template file in the project's .bushido dir" do
        Tane::Helpers::Example.email_template_file_path("valid_template").should == ".bushido/emails/valid_template.yml"
      end
    end

    describe "tane_file_path" do
      it "should return path to xsycurrent project's .bushido/tane.yml" do
        Tane::Helpers::Example.tane_file_path == ".bushido/tane.yml"
      end
    end

    describe "credentials_file_path" do
      it "should return path to user's Bushido credentials file" do
        Tane::Helpers::Example.credentials_file_path == "#{ENV['HOME']}/.bushido/credentials.yml"
      end
    end

    describe "logged_in?" do
      it "should return true if the credentials file exists" do
        File.should_receive(:exists?).and_return(true)
        Tane::Helpers::Example.logged_in?.should be_true
      end

      it "should return false if the credentials file does not exist" do
        File.should_receive(:exists?).and_return(false)
        Tane::Helpers::Example.logged_in?.should be_false
      end
    end

    describe "in_rails_dir?" do
      it "it should return true if the current dir has a rails dir" do
        Dir.should_receive(:exists?).at_least(1).and_return(true)
        Tane::Helpers::Example.in_rails_dir?.should be_true
      end

      it "should return false if the current dir does not have both script and rails dir" do
        Dir.should_receive(:exists?).at_least(1).and_return(false)
        Tane::Helpers::Example.in_rails_dir?.should be_false
      end
    end

    describe "bushido_app_exists?" do
      it "it should return true if the tane.yml and email.yml exists in the current directory" do
        File.should_receive(:exists?).twice.and_return(true)
        Tane::Helpers::Example.bushido_app_exists?.should be_true
      end
    end

    describe "username" do
      it "should return the username from the credentials" do
        Tane::Helpers::Example.should_receive(:credentials).and_return({:username=>"username"})
        Tane::Helpers::Example.username.should == "username"
      end
    end

    describe "password" do
      it "should return the password from the credentials" do
        Tane::Helpers::Example.should_receive(:credentials).and_return({:password=>"password"})
        Tane::Helpers::Example.password.should == "password"
      end
    end

    describe "make_global_bushido_dir" do
      it "should create a .bushido dir in the user's $HOME directory" do
        FileUtils.should_receive(:mkdir_p).with("#{ENV['HOME']}/.bushido")
        Tane::Helpers::Example.make_global_bushido_dir
      end
    end

    describe "make_app_bushido_dir" do
      it "should create a .bushido dir in the current dir if it does not have one" do
        Tane::Helpers::Example.should_receive(:bushido_app_exists?).and_return(false)
        FileUtils.should_receive(:mkdir_p).with(".bushido")
        Tane::Helpers::Example.make_app_bushido_dir
      end

      it "should *not* create a .bushido in the current dir if it already has not" do
        Tane::Helpers::Example.should_receive(:bushido_app_exists?).and_return(true)
        expect {
          Tane::Helpers::Example.make_app_bushido_dir
        }.to raise_error(SystemExit)
      end
    end

    describe "save_credentials" do
      it "should save the username and the password in the user's bushido_dir" do
        File.should_receive(:open)
        Tane::Helpers::Example.save_credentials("email", "auth_token")
      end
    end

    describe "prompt_for_credentials" do
      it "should promt the user for credentials using HighLine" do
        Tane::Helpers::Example.term.should_receive(:ask).twice.and_return("test")
        Tane::Helpers::Example.prompt_for_credentials
      end

      it "should return an array with email and password" do
        Tane::Helpers::Example.term.should_receive(:ask).twice.and_return("test")
        Tane::Helpers::Example.prompt_for_credentials.should be_kind_of(Array)
      end
    end

    describe "warn_if_credentials" do

      before :each do
        Tane::Helpers::Example.should_receive(:logged_in?).and_return(true)
        Tane::Helpers::Example.should_receive(:username).and_return("test_user")
      end
      
      it "should warn that the user is already logged in if the credentials file exists" do

        Tane::Helpers::Example.term.should_receive(:agree).and_return(true)
        Tane::Helpers::Example.warn_if_credentials
      end
      
      it "should skip if the user says no to reset credentials" do
        Tane::Helpers::Example.term.should_receive(:agree).and_return(false)
        expect {
          Tane::Helpers::Example.warn_if_credentials
        }.to raise_error(SystemExit)
      end

      it "should return if the user says yes to reset credentials" do
        Tane::Helpers::Example.term.should_receive(:agree).and_return(true)
        Tane::Helpers::Example.warn_if_credentials
      end
    end

    describe "bushido_envs" do
      it "should return the read the data in .bushido/tane.yml and return a hash" do
        File.should_receive(:read).and_return('HOSTING_PLATFORM: developer')
        Tane::Helpers::Example.bushido_envs.should == {"HOSTING_PLATFORM"=> "developer"}
      end
    end

    describe "base_url" do
      it "should return http://localhost:3000 by default if the --host, --scheme and --port options are not set on the command line" do
        Tane::Helpers::Example.base_url == "http://localhost:3000"
      end
    end

    describe "mail_url" do
      it "should return url to local app's Bushido::Mail#index action at/bushido/mail" do
        mail_url = "#{::Tane::Helpers::Example.base_url}/bushido/mail"
        Tane::Helpers::Example.mail_url.should == mail_url
      end
    end

    describe "post" do
      before :each do
        Tane::Helpers::Example.should_receive(:bushido_envs).and_return({"BUSHIDO_APP_KEY"=>"abc123"})
        @data = {}
        @url = "http://example.com"
        RestClient.should_receive(:put).with(@url, @data, :content_type => :json, :accept => :json).and_return(@data.to_json)
      end

      it "should post to the given url with the given data" do
        Tane::Helpers::Example.post(@url, @data)
      end

      it "should display the result on the terminal if the verbose option is set" do
        Tane::Helpers::Example.opts.verbose=true
        Tane::Helpers::Example.term.should_receive(:say).at_least(1)
        Tane::Helpers::Example.post(@url, @data)
      end
      
      it "should return a hash" do
        Tane::Helpers::Example.post(@url, @data).should be_kind_of(Hash)
      end
    end
  end
    
end
