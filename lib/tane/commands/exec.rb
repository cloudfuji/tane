class Tane::Commands::Exec < Tane::Commands::Base

  class << self
    def process(args)
      authenticate_user
      cloudfuji_envs.each_pair do |key, value|
        ENV[key] = value
      end
      
      command = args.join(' ')
      
      if command.empty?
        term.say("please enter a command for tane exec to run. example:")
        term.say("\t tane exec rails s")
        
        exit 1
      end
      
      exec command
    end

    def help_text
      <<-EOL
Usage:

    tane exec any_command
    
Executes any command specified in a simulated Cloudfuji environment. The following example shows you how to run rails applications.

    tane exec rails s

This is how you should be running Cloudfuji rails applications locally. All the configuration required for `tane exec` is obtained from `.cloudfuji` directory in the current directory. This can only be used if `tane init` has been run in the current directory.
EOL
    end
  end

end
