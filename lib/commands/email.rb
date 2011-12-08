class Tane::Commands::Email < Tane::Commands::Base
  class << self
    def process(args)
      send_email(args.first)
    end

    def send_email(email_name)
      email = render_email(email_name)

      # TODO: Display a list of emails I do know how to send
      if email.nil?
        term.say("Couldn't find any email with the title '#{email_name}', are you sure it's in .bushido/emails.yml? ")

        exit 1
      end

      post(mail_url, email)
    end

    def render_email(name)
      verbose_say("Loading emails from #{email_template_file_path}")
      YAML.load(ERB.new(File.read( email_template_file_path )).result)[name]
    end
  end
end
