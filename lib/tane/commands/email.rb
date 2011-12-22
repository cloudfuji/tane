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
      YAML.load(ERB.new(File.read( email_template_file_path )).result)[name]
    end

    def help_text
      <<-EOL
Usage:

    tane email [email_template_name]
   
Simulates an incoming email event in the app running locally, using the template provided. Details on how to create a template are discussed later in this document.

To list email templates defined for the application, run

    tane email
EOL
    end

  end
end
