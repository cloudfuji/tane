require "spec_helper"

describe Tane::Commands::Exec do

  subject { Tane::Commands::Exec }
  
  describe ".process" do
    it "should call exec to replace the current process with the arguments passed" do
      args = ['foo', 'bar']

      subject.should_receive(:authenticate_user).and_return(true)
      subject.should_receive(:cloudfuji_envs).and_return({})
            
      subject.should_receive(:exec).with(args.join(' '))
      subject.process(args)
    end
  end

end
