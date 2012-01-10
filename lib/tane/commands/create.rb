class Tane::Commands::Create < Tane::Commands::Base

  class << self
    def process(args)
      authenticate_user
      app_name = args[0] ||= term.ask("Please enter a name for your new app:     ") { |app_name| app_name }
      template_url = ENV['KIMONO_URL'] || "https://raw.github.com/Bushido/kimono/master/kimono.rb"

      print "Creating a new Bushido rails app in #{ app_name } ... "

      system("rails new #{app_name} -m #{ template_url } > tane.log")

      Dir.chdir("./#{app_name}")do
        system("bundle exec tane init > ../tane.log")
      end

      success_messages = ["Let the hacking commence!",
                          "Hacks and glory await!",
                          "Hack and be merry!",
                          "Your hacking starts... NOW!",
                          "May the source be with you!",
                          "Take this demi-REPL, dear friend, and may it serve you well.",
                          "Lemonodor-fame is but a hack away!",
                          "Go forth to #{ app_name }, and hack for all you're worth - for all humankind!"]

      success_message = success_messages[ rand(success_messages.length) ]

      FileUtils.mv("./tane.log", "./#{ app_name }/log/tane.log")
      puts "Finished successfully!"
      puts "Your app is now in ./#{ app_name } . #{ success_message }"
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
