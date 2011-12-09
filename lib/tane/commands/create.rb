class Tane::Commands::Create < Tane::Commands::Base
  def self.process(args)
    authenticate_user
    app_name = args[0] ||= term.ask("Please enter a name for your new app:     ") { |app_name| app_name }
    puts "omg app name?"
    puts args.inspect
    puts app_name
    system "bundle exec rails #{app_name} -m https://raw.github.com/Bushido/kimono/master/kimono.rb"
  end
end
