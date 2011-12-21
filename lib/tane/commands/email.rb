class Tane::Commands::Email < Tane::Commands::Base
  class << self
    def process(args)
      list_email_templates if args.first == "list"
      send_email(args[1])  if args.first == "send"
    end

    def list_email_templates
      email_templates = Dir["#{email_templates_path}/*.yml"]
      "#{email_templates.count} email templates found for this app:"
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

      post(mail_url, email)
    end

    def render_email(name)
      YAML.load(ERB.new(File.read( email_template_file_path(name) )).result)
    end
  end
end
