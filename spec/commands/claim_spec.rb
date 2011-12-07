require "spec_helper"

describe Tane::Commands::Claim do

  describe ".process" do

    before :each do
      @args = ["valid_email", "valid_ido_id"]
    end
    
    it "should notify the local app about an App.claimed event" do
      Time.should_receive(:now).at_least(1).and_return("valid_time")

      event = {
        'category' => 'app',
        'event'    => 'claimed',
        'data'     => {
          'time'   => Time.now,
          'ido_id' => @args.last,
          'email' => @args.first
        }
      }

      Tane::Commands::Claim.should_receive(:post).
        with(Tane::Commands::Claim.data_url, event)

      Tane::Commands::Claim.process(@args)
    end

  end
end

  
