require 'commands/app'

class Tane::Commands::Login < Tane::Commands::Base
  class << self
    def process(args)
      warn_if_credentials

      term.say  "Let's connect you with bushido:"
      email, password = prompt_for_credentials
      term.say "contacting bushido, please wait..."
      auth_token, errors = Tane::Helpers::Bushido.verify_credentials(email, password)

      if auth_token.nil?
        term.say("Invalid username, or password, sorry! Don't worry though, we'll get you through this!")
        if term.agree("would you like to try signing up with those credentials? Y/N")
          term.say "Trying to sign up with those credentials..."

          auth_token, errors = Tane::Helpers::Bushido.signup(email, password)
          if auth_token.nil?
            term.say "Couldn't signup - "
            errors.each do |field|
              term.say "\n"
              field.last.each do |error|
                term.say "  #{field.first} #{error} \n"
              end
            end
            
            exit
          else
            term.say "Ok, you're signed up as #{email}!"
          end
        else
          term.say "Please try one of the following:"
          term.say "\t1. Log in again with different credentials"
          term.say "\t2. Send us a help message from the command line via `tane support 'Hey guys, having trouble logging in with tane...'`"
          term.say "\t3. Contact us by email at support@gobushido.com if you're having trouble!"
          term.say "Seriously, isn't it cool to be able to send a support message straight from the cli? It's like you're the fonz"

          exit
        end
      end
      term.say "Done!"
      term.say "Saving credentials"
      save_credentials(email, auth_token)
    end
  end
end
