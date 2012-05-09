require 'fileutils'

class Tane::Commands::Create < Tane::Commands::Base
  class << self
    def process(args)
      verbose_say("Authenticating you...")
      authenticate_user
      verbose_say("done!")
      
      app_name = args[0] ||= term.ask("Please enter a name for your new app:     ") { |app_name| app_name }
      target_path = term.ask("Create app in path (defaults to [#{Dir.pwd}/#{app_name}]: ")
      target_path = "#{Dir.pwd}/#{app_name}" if target_path.to_s == ""

      template_url = ENV['KIMONO_URL'] || "https://raw.github.com/Cloudfuji/kimono/master/kimono.rb"

      print "Creating a new Cloudfuji rails app in #{ target_path } (please wait, it'll take a few minutes) ...    "

      FileUtils.mkdir_p target_path

      start_throbber!

      File.open("tane.log", "w") do |file|
        IO.popen("rails _#{Tane::RAILS_VERSION}_ new #{ target_path } --quiet --template=#{ template_url } 2>&1 /dev/null", :error => [:child, :out]) do |io|
          file.puts(io.read)
        end
      end
      verbose_say("Finished creating rails app, initializing Cloudfuji resources...")

      Dir.chdir("#{ target_path }")do
        File.open("tane.log", "w") do |file|
          verbose = "--verbose" if opts.verbose
          verbose ||= ""
          IO.popen("bundle exec tane init #{verbose}", :error => [:child, :out]) do |io|
            file.puts(io.read)
          end
        end
      end

      verbose_say("done!")

      stop_throbber!

      success_messages = ["Let the hacking commence!",
                          "Hacks and glory await!",
                          "Hack and be merry!",
                          "Your hacking starts... NOW!",
                          "May the source be with you!",
                          "Take this demi-REPL, dear friend, and may it serve you well.",
                          "Lemonodor-fame is but a hack away!",
                          "Go forth to #{ app_name }, and hack for all you're worth - for all humankind!"]

      fujis = ["Sean", "Kevin", "Akash"]

      success_message = success_messages[ rand(success_messages.length) ]
      fujis        = fujis[ rand(fujis.length)         ]

      FileUtils.mv("./tane.log", "#{ target_path }/log/tane.log")
      term.say "  Finished successfully!"
      term.say "Your app is now in #{ target_path }"
      
      
      Dir.chdir("#{ target_path }") do
        begin
          term.say "Migrating your new app to setup the basic models..."
          suppress_env_vars("BUNDLE_BIN_PATH", "BUNDLE_GEMFILE", "RUBYOPT") do
            verbose_say("migrating database!")
            system("bundle exec tane exec rake db:migrate")
          end

          File.open(".gitignore", "a") { |gitignore| gitignore.puts(".cloudfuji/tane.yml" ) }

          term.say "Initializing git repo..."
          suppress_env_vars("BUNDLE_BIN_PATH", "BUNDLE_GEMFILE", "RUBYOPT") do
            verbose_say("initializing git repo")
            system("git init")
            system("git add .")
          end

          term.say "Launching your new app!"
          term.say "Check out once rails has finished booting http://localhost:3000"
          term.say "#{fujis} says, \"#{ success_message }\""

          # Do this in the background, it'll wait up to 120 seconds
          # for the rails server to start up and launch a browser as
          # soon as it's ready
          verbose_say("Launching `tane open' in the background..")
          system("tane open&")
          verbose_say("done!")

          suppress_env_vars("BUNDLE_BIN_PATH", "BUNDLE_GEMFILE", "RUBYOPT") do
            verbose_say("launching rails app!")
            exec("bundle exec tane exec rails s")
          end
        rescue Exception => ex
          term.say "Oh no we tried to launch the app but failed. Please try launching it yourself with \n bundle exec tane exec rails s \n if you have problems let us know at support@cloudfuji.com"
        end
      end

    end

    def help_text
      <<-EOL
Usage:

    tane create 'app_name'

Creates a new Cloudfuji-enabled rails app from scratch and launches it. Use this to get started with Cloudfuji quickly and easily

    tane create my_example_app
EOL
    end
  end

end
