require 'erb'
require 'fileutils'
require 'yaml'
require 'rest-client'
require 'json'

module Tane
  module Helpers
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      @should_throb = false

      def term
        @hl ||= HighLine.new
      end

      def verbose_say(message)
        term.say(message) if opts.verbose
      end
      
      def opts
        @opts ||= OpenStruct.new
      end

      def bushido_url
        ENV['BUSHIDO_URL'] || "http://bushi.do"
      end
      
      def bushido_dir
        "#{ENV['HOME']}/.bushido"
      end

      def email_template_file_path(template_name)
        "#{email_templates_path}/#{template_name}.yml"
      end
      
      def email_templates_path
        ".bushido/emails"
      end

      def tane_file_path
        ".bushido/tane.yml"
      end

      def credentials_file_path
        "#{bushido_dir}/credentials.yml"
      end

      def credentials
        YAML.load(ERB.new(File.read( credentials_file_path )).result)
      end

      def destroy_credentials
        File.delete(credentials_file_path)
      end

      def logged_in?
        File.exists?(credentials_file_path)
      end

      def in_rails_dir?
        Dir.exists?('./rails') || Dir.exists?('./script')
      end

      def bushido_app_exists?
        File.exists?('.bushido/tane.yml') and File.directory?('.bushido/emails')
      end

      def username
        begin
          return credentials[:username]
        rescue
          term.say "Looks like your Bushido credentials file is corrupted - try deleting ~/.bushido/credentials.yml and then logging in again"
          exit 1
        end
      end

      def password
        begin
          return credentials[:password]
        rescue
          term.say "Looks like your Bushido credentials file is corrupted - try deleting ~/.bushido/credentials.yml and then logging in again"
          exit 1
        end
      end

      def make_global_bushido_dir
        FileUtils.mkdir_p bushido_dir
      end

      def make_app_bushido_dir
        if bushido_app_exists?
          term.say("There's already a Bushido app created for this local rails app. If you'd like to create a new one, please remove the .bushido file in this directory")

          exit 1
        else
          FileUtils.mkdir_p '.bushido/emails'
        end
      end
      
      def authenticate_user
        unless logged_in?
          Tane::Commands::Login.process(:exit => false)
        end
      end

      def save_credentials(username, password)
        new_credentials = credentials rescue {}
        new_credentials[:username] = username
        new_credentials[:password] = password
        Dir.mkdir(bushido_dir) unless File.exists?(bushido_dir)
        File.open(credentials_file_path, 'w+') { |file| file.puts YAML.dump(new_credentials) }
      end

      def prompt_for_credentials
        email = term.ask("Enter your email:     ") { |email| email }
        password = term.ask("Enter your password:  ") { |password| password.echo = false }
        return email.to_s, password.to_s
      end

      def warn_if_credentials
        if logged_in?
          if term.agree("This computer already has the Bushido user '#{username}' logged in, are you sure you would like to proceed? Y/N")
            term.say("Ok, continuing along like nothing happened")
          else
            term.say("Phew, I think we might have dodged a bullet there!")
            exit
          end
        end
      end

      def bushido_envs
        YAML.load(ERB.new(File.read( '.bushido/tane.yml' )).result)
      end

      def base_url
        "#{opts.scheme}://#{opts.host}:#{opts.port}"
      end

      def data_url
        "#{base_url}/bushido/data"
      end

      def support_url
        "#{bushido_url}/support/v1/message"
      end

      def envs_url
        "#{base_url}/bushido/envs"
      end

      def mail_url
        "#{base_url}/bushido/mail"
      end

      def post(url, data)
        data['key'] = bushido_envs["BUSHIDO_APP_KEY"]

        verbose_say("RestClient.put #{url}, #{data.inspect}, :content_type => :json, :accept => :json)")
        result = JSON(RestClient.put url, data, :content_type => :json, :accept => :json)
        verbose_say(result.inspect)

        result
      end

      def repeat_every(interval, &block)
        Thread.new do
          loop do
            start_time = Time.now
            yield
            elapsed = Time.now - start_time
            sleep([interval - elapsed, 0].max)
          end
        end
      end

      def start_throbber!
        throbber_frames = ['|', '/', '-', '\\', 'X']
        frame_counter = 0

        @should_throb = true

        thread = repeat_every(0.5) do
          if @should_throb
            print "\x08\x08\x08"
            frame_counter += 1
            frame_counter = 0 if frame_counter == throbber_frames.length
            print "#{throbber_frames[frame_counter]}  "
          end
        end

      end

      def stop_throbber!
        @should_throb = false
      end

      def should_throb
        @should_throb
      end

      def should_throb=(value)
        @should_throb = value
      end

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

      def try_for(options, &block)
        options[:seconds] ||= 30
        options[:sleep]   ||= 5

        start = Time.now
        elapsed = 0

        while elapsed < options[:seconds]
          return true if yield elapsed
          sleep options[:sleep]
          elapsed = Time.now - start
        end

        return false
      end      
    end
  end
end
