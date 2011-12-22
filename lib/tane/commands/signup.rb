class Tane::Commands::Signup < Tane::Commands::Base
  include Tane::Helpers

  class << self
    def process(args)
      warn_if_credentials

      email, password = prompt_for_credentials

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

      term.say "Done!"
      term.say "Saving credentials"
      save_credentials(email, auth_token)
    end


    def help_text
      <<-EOL
Usage:

    tane signup
    
Prompts you to signup for a Bushido account.
EOL
    end
  end

end
