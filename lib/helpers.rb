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
      def term
        @hl ||= HighLine.new
      end

      def verbose_say(message)
        term.say(message) if opts.verbose
      end
      
      def opts
        @opts ||= {}
      end

      def bushido_url
        ENV['BUSHIDO_URL'] || "http://bushi.do"
      end
      
      def bushido_dir
        "#{ENV['HOME']}/.bushido"
      end

      def email_template_file_path
        ".bushido/emails.yml"
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
        Dir.exists?('.bushido')
      end

      def username
        credentials[:username]
      end

      def password
        credentials[:password]
      end

      def make_global_bushido_dir
        FileUtils.mkdir_p bushido_dir
      end

      def make_app_bushido_dir
        if bushido_app_exists?
          term.say("There's already a Bushido app created for this local rails app. If you'd like to create a new one, please remove the .bushido file in this directory")

          exit 1
        else
          FileUtils.mkdir_p '.bushido'
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
    end
  end
end
