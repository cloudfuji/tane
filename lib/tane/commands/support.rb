class Tane::Commands::Support < Tane::Commands::Base
  class << self
    def process(args)
      message = term.ask("Your message to the Bushido clan: ")
      send_message_to_bushido(message)
    end


    def send_message_to_bushido(message)
      term.say("Sent the bushido team your message:")
      term.say("\t#{message}")
      term.say("Boy are they gonna be excited to hear from you, #{username}")
    end

    def help_text
      <<-EOL
Usage:

    tane support

Prompts you for a message to send to the Bushido team.
EOL
    end
  end

end
