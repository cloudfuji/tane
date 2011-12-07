class Tane::Commands::Logout < Tane::Commands::Base
  class << self
    def process(args)
      if logged_in?
        term.say "Logging out #{username} from this computer..."
        destroy_credentials
        term.say "Finished! All gone! Buh bye!"
      else
        term.say "Couldn't find any Bushido account on this computer... kind of lonesome in that way, what with just you and me and all..."
      end
    end
  end
end
