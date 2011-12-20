class Tane::Commands::Create < Tane::Commands::Base
  def self.process(args)
    authenticate_user
    app_name = args[0] ||= term.ask("Please enter a name for your new app:     ") { |app_name| app_name }

    system "bundle exec rails new #{app_name} -m https://raw.github.com/Bushido/kimono/master/kimono.rb"
  end
end
