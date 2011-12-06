class Tane::Commands::Signup < Tane::Commands::Base
  include Tane::Helpers

  class << self
    def process(args)
      warn_if_credentials

      email, password = prompt_for_credentials

      auth_token = Tane::Helpers::Bushido.signup(email, password)

      if auth_token.nil?
        term.say "Couldn't signup, maybe there was an error? "
        # TODO: show the errors
        exit
      else
        term.say "Ok, you're signed up as #{email}!"
      end

      term.say "Done!"
      term.say "Saving credentials"
      save_credentials(email, auth_token)
    end
  end
end
