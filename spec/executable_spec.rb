require "spec_helper"

describe "executable" do

  describe "help" do
    it "should display help message on --help switch" do
      pending
    end

    it "should display help message on -h switch" do
      pending
    end
  end

  
  describe "init" do
    describe "if the credentials are not available at $HOME/.bushido" do
      it "should ask the user to login" do
        pending
      end

      it "should create the .bushido dir" do
        pending
      end
    end

    
    describe "if the credentials are available" do
      it "should use the credentials from the $HOME/.bushido" do
        pending
      end
    end

    
    describe "gitignore" do
      it "should be created if not already present" do
        pending
      end

      it ".bushido be added if not already present" do
        pending
      end

      it "should *not* add to the gitignore file if already present" do
        pending
      end
    end


    describe ".bushido/tane.yml file" do
      it "should be created on init" do
        pending
      end

      it "should contain the default values for bushido env variables" do
        pending
      end
    end

  end

  
  describe "exec" do
    it "should execute a command with the environment values from the .bushido/tane.yml file" do
      pending
    end

    it "should pass on the arguments to the command to be executed" do
      pending
    end
  end

  
  describe "event:" do
    describe "send" do
      it "should send an event notification to the bushido data controller in the local app at /data" do
        pending
      end
    end
  end

end
