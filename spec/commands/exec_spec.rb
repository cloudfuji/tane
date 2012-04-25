require "spec_helper"

describe Tane::Commands::Exec do

  describe ".process" do
    it "should call exec to replace the current process with the arguments passed" do
      args = ['foo', 'bar']

      Tane::Commands::Exec.should_receive(:authenticate_user).and_return(true)
      Tane::Commands::Exec.should_receive(:cloudfuji_envs).
        and_return({})
            
      Tane::Commands::Exec.should_receive(:exec).with(args.join(' '))
      Tane::Commands::Exec.process(args)
    end
  end

end
