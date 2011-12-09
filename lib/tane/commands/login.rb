require 'tane/commands/app'

class Tane::Commands::Login < Tane::Commands::Base
  class << self
    def process(args)
      email, password = warn_if_credentials_and_prompt
      
      auth_token = verify_or_signup(email, password)
      
      term.say "Done!"
      term.say "Saving credentials"
      save_credentials(email, auth_token)
    end
    
    
    def warn_if_credentials_and_prompt
      warn_if_credentials
      
      term.say "Let's log you in:"
      email, password = prompt_for_credentials
    end
    
    
    def verify_or_signup(email, password)
      term.say "contacting bushido, please wait..."
      auth_token, errors = Tane::Helpers::Bushido.verify_credentials(email, password)
      
      return auth_token if not auth_token.nil?

      if auth_token.nil?
        term.say("Invalid username, or password, sorry! Don't worry though, we'll get you through this!")

        # returns auth_token on success
        return signup_and_notify(email, password) if term.agree("would you like to try signing up with those credentials?")
          
        display_help_messages_and_exit
      end
    end
    
    
    def signup_and_notify(email, password)
      term.say "Trying to sign up with those credentials..."
      auth_token, errors = Tane::Helpers::Bushido.signup(email, password)

      display_errors_and_exit(errors) if auth_token.nil?
      
      term.say "Ok, you're signed up as #{email}!"
      return auth_token
    end

    
    def display_errors_and_exit(errors)
      term.say "Couldn't signup - "

      errors.each do |field|
        term.say "\n"
        field.last.each do |error|
          term.say "  #{field.first} #{error} \n"
        end
      end
      exit
    end


    def display_help_messages_and_exit
      messages = [
        "Please try one of the following:",
        "\t1. Log in again with different credentials",
        "\t2. Send us a help message from the command line via `tane support 'Hey guys, having trouble logging in with tane...'`",
        "\t3. Contact us by email at support@gobushido.com if you're having trouble!",
        "Seriously, isn't it cool to be able to send a support message straight from the cli? It's like you're the fonz"]

      messages.each do |message|
        term.say message
      end
      
      exit
    end

  end
end
