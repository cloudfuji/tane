class Tane::Commands::Init < Tane::Commands::Base

  class << self
    def process(args)
      verbose_say("authenticating you...")
      authenticate_user
      verbose_say("done!")
      if in_rails_dir?
        verbose_say("In a rails directory, tane initializing...")
        Tane::Helpers::Init.initialize_app
        verbose_say("finished initializing!")
      else
        term.say("You have to be in the local rails app's root directory when running `tane init`")
        exit 1
      end
    end

    def help_text
      <<-EOL
Usage:

    tane init
    
Creates a `.cloudfuji` directory within the directory of the rails application. That holds all the config that enables you to run applications and commands in a Cloudfuji environment. It also deploys a development application on Cloudfuji that allows your local application to use resources on the Cloudfuji platform.
EOL
    end
  end

end
