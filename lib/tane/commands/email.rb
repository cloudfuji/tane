class Tane::Commands::Email < Tane::Commands::Base
  class << self
    def process(args)
      if args.count == 0
        list_email_templates
      else
        send_email(args.first)
      end
    end

    def list_email_templates
      email_templates = Dir["#{email_templates_path}/*.yml"]
      term.say "#{email_templates.count} email templates found for this app:"
      email_templates.each { |template| term.say template }
    end
    
    def send_email(email_name)
      email = render_email(email_name)

      if email.nil?
        term.say "Couldn't find any email with the title '#{email_name}', are you sure there is a .bushido/emails/#{email_name}.yml? "
        term.say "Here are the email templates for this app..."
        list_email_templates

        exit 1
      end

      email = email[email_name]

      post(mail_url, email)
    end

    def render_email(name)
      YAML.load(ERB.new(File.read( email_template_file_path(name) )).result)
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
