require 'launchy'

    # Takes a list of ENV vars, records their value,
    # sets them to null, runs the block, then ensures
    # the ENV vars are restored at the end.
    def suppress_env_vars(*vars, &block)
      cache = {}
      vars.each do |var|
        cache[var] = ENV[var]
      end

      begin      
        vars.each do |var|
          ENV[var] = nil
        end
        yield block
      ensure
        cache.each_pair do |key, value|
          ENV[key] = value
        end
      end
    end


class Tane::Commands::Create < Tane::Commands::Base

  class << self
    def process(args)
      authenticate_user
      app_name = args[0] ||= term.ask("Please enter a name for your new app:     ") { |app_name| app_name }
      template_url = ENV['KIMONO_URL'] || "https://raw.github.com/Bushido/kimono/master/kimono.rb"

      print "Creating a new Bushido rails app in ./#{ app_name } (please wait, it'll take a few minutes) ...  "

      start_throbber!

      File.open("tane.log", "w") do |file|
        IO.popen("rails new #{app_name} -m #{ template_url }", :error => [:child, :out]) do |io|
          file.puts(io.read)
        end
      end


      Dir.chdir("./#{app_name}")do
        File.open("tane.log", "w") do |file|
          IO.popen("bundle exec tane init", :error => [:child, :out]) do |io|
            file.puts(io.read)
          end
        end
      end

      stop_throbber!

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
      puts "  Finished successfully!"
      puts "Your app is now in ./#{ app_name } . #{ success_message }"
      
      Dir.chdir("./#{app_name}") do
        puts "Launching your new app at http://localhost:3000"
        begin
          suppress_env_vars("BUNDLE_BIN_PATH", "BUNDLE_GEMFILE", "RUBYOPT") do
            system("bundle exec rails s -d && launchy http://localhost:3000")
          end
        rescue Exception => ex
          puts "Oh no we tried to launch the app but failed. Please try launching it yourself with \n bundle exec tane exec rails s \n if you have problems let us know at support@bushi.do"
        end
      end

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
