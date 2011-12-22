class Tane::Commands::Help < Tane::Commands::Base

  class << self
    def process(args)
      if args.count == 0
        puts opts.help_text
        return
      end
      help_for_command args.first.capitalize if args.count != 0
    end
    
    def help_for_command(command)
      klass = Tane::Commands.const_get(command)
      Tane::Commands.const_missing(command) if not klass.respond_to? :help_text
      term.say "\n#{klass.help_text}\n"
    end

    def help_text
      <<-EOL
Usage:

    tane help [command]

Displays the help message with the list commands tane supports. For details about usage about each each command use `tane help name`, where _name_ is the name of the command you need information about. For example

    tane help support
  
displays the information about the support command.
EOL
    end
  end

end
