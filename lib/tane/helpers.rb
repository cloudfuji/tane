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

      def cloudfuji_url
        ENV['CLOUDFUJI_URL'] || "http://bushi.do"
      end
      
      def cloudfuji_dir
        "#{ENV['HOME']}/.cloudfuji"
      end

      def email_template_file_path(template_name)
        "#{email_templates_path}/#{template_name}.yml"
      end
      
      def email_templates_path
        ".cloudfuji/emails"
      end

      def tane_file_path
        ".cloudfuji/tane.yml"
      end

      def credentials_file_path
        "#{cloudfuji_dir}/credentials.yml"
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

      def cloudfuji_app_exists?
        File.exists?('.cloudfuji/tane.yml') and File.directory?('.cloudfuji/emails')
      end

      def username
        begin
          return credentials[:username]
        rescue
          term.say "Looks like your Cloudfuji credentials file is corrupted - try deleting ~/.cloudfuji/credentials.yml and then logging in again"
          exit 1
        end
      end

      def password
        begin
          return credentials[:password]
        rescue
          term.say "Looks like your Cloudfuji credentials file is corrupted - try deleting ~/.cloudfuji/credentials.yml and then logging in again"
          exit 1
        end
      end

      def make_global_cloudfuji_dir
        FileUtils.mkdir_p cloudfuji_dir
      end

      def make_app_cloudfuji_dir
        if cloudfuji_app_exists?
          term.say("There's already a Cloudfuji app created for this local rails app. If you'd like to create a new one, please remove the .cloudfuji file in this directory")

          exit 1
        else
          FileUtils.mkdir_p '.cloudfuji/emails'
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
        Dir.mkdir(cloudfuji_dir) unless File.exists?(cloudfuji_dir)
        File.open(credentials_file_path, 'w+') { |file| file.puts YAML.dump(new_credentials) }
      end

      def prompt_for_credentials
        email = term.ask("Enter your email:     ") { |email| email }
        password = term.ask("Enter your password:  ") { |password| password.echo = false }
        return email.to_s, password.to_s
      end

      def warn_if_credentials
        if logged_in?
          if term.agree("This computer already has the Cloudfuji user '#{username}' logged in, are you sure you would like to proceed? Y/N")
            term.say("Ok, continuing along like nothing happened")
          else
            term.say("Phew, I think we might have dodged a bullet there!")
            exit
          end
        end
      end

      def cloudfuji_envs
        YAML.load(ERB.new(File.read( '.cloudfuji/tane.yml' )).result)
      end

      def base_url
        "#{opts.scheme}://#{opts.host}:#{opts.port}"
      end

      def data_url
        "#{base_url}/cloudfuji/data"
      end

      def support_url
        "#{cloudfuji_url}/support/v1/message"
      end

      def envs_url
        "#{base_url}/cloudfuji/envs"
      end

      def mail_url
        "#{base_url}/cloudfuji/mail"
      end

      def post(url, data)
        data['key'] = cloudfuji_envs["CLOUDFUJI_APP_KEY"]

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
