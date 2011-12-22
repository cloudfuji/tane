class Tane::Commands::Create < Tane::Commands::Base

  class << self
    def process(args)
      authenticate_user
      app_name = args[0] ||= term.ask("Please enter a name for your new app:     ") { |app_name| app_name }
      system "bundle exec rails new #{app_name} -m https://raw.github.com/Bushido/kimono/master/kimono.rb"      
    end

    def help_text
      <<-EOL
Usage:

    tane claim email ido_id

Notifies the app of an App.claimed event to the locally running app when the email and ido_id are passed.

    tane claim john@example.com 6h284ah92jcj9m2sv21f
EOL
    end
  end

end
