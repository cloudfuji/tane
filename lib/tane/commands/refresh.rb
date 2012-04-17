class Tane::Commands::Refresh < Tane::Commands::Base

  class << self
    def process(args)
      if in_rails_dir?
        Tane::Helpers::Init.update_app
      else
        term.say("You have to be in the local rails app's root directory when running `tane update`")
        
        exit 1
      end
    end

    def help_text
      <<-EOL
Usage:

    tane refresh

Updates the Cloudfuji environment for the local application from the
latest settings from the Cloudfuji server.
EOL
    end   
  end

end
