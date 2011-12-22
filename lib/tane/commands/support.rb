class Tane::Commands::Support < Tane::Commands::Base
  class << self
    def process(args)
      message = term.ask("Your message to the Bushido clan: ")
      send_message_to_bushido(message)
    end

    def send_message_to_bushido(message)
      support_data = {}
      support_data[:source]  = "tane"
      support_data[:email]   = email_from_credentials_or_prompt
      support_data[:message] = message

      RestClient.post support_url, support_data

      term.say("Send the bushido team your message:")
      term.say("\t#{message}")
      term.say("Boy are they gonna be excited to hear from you, #{support_data[:email]}")
    end

    def email_from_credentials_or_prompt
      return username if logged_in?
      return term.ask("And your email address is: ")
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
