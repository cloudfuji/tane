class Tane::Commands::Init < Tane::Commands::Base

  class << self
    def process(args)
      authenticate_user
      if in_rails_dir?
        Tane::Helpers::Init.initialize_app
      else
        term.say("You have to be in the local rails app's root directory when running `tane init`")
        exit 1
      end
    end

    def help_text
      <<-EOL
Usage:

    tane init
    
Creates a `.bushido` directory within the directory of the rails application. That holds all the config that enables you to run applications and commands in a Bushido environment. It also deploys a development application on Bushido that allows your local application to use resources on the Bushido platform.
EOL
    end
  end

end
