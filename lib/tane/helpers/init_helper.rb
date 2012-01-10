class Tane::Helpers::Init
  include Tane::Helpers

  class << self
    def initialize_app
      term.say "Initializing a local Bushido app for this rails app..."
      if bushido_app_exists?
        update_app
      else
        app = create_app
        make_app_bushido_dir
        save_envs(get_app_envs(app['name']))
        save_emails
      end

      term.say "Finished successfully! Check out .bushido/tane.yml for the env vars if you care, or .bushido/emails/#{example_email_template.keys.first}.yml to create email templates to test with"
    end

    def update_app
      save_envs(get_app_envs(bushido_envs['BUSHIDO_NAME']))
    end

    # TODO: Replace envs_template with values retrieved from Bushido side
    def save_envs(env_vars)
      if File.exists?('.bushido/tane.yml')
        return if not term.agree('.bushido/tane.yml already exists! Are you sure you want to overwrite it? Y/N')
      end

      File.open('.bushido/tane.yml', 'w+') { |file| file.puts YAML.dump(envs_template(env_vars)) }
    end

    def save_emails
      if File.exists?("#{email_templates_path}/#{example_email_template.keys.first}")
        return if not term.agree("#{example_email_template.keys.first} already exists! Are you sure you want to overwrite it? Y/N")
      end

      File.open("#{email_templates_path}/#{example_email_template.keys.first}", "w") do |file|
        file.puts email_template_explanation
        file.puts YAML.dump(example_email_template)
      end
    end

    def envs_template(app_envs)
      envs = {}
      env_var_keys = [
        'APP_TLD',              'BUNDLE_WITHOUT',   'BUSHIDO_APP',          'BUSHIDO_APP_KEY',
        'BUSHIDO_DOMAIN',       'BUSHIDO_EVENTS',   'BUSHIDO_HOST',         'BUSHIDO_NAME',
        'BUSHIDO_PROJECT_NAME', 'BUSHIDO_SALT',     'BUSHIDO_SUBDOMAIN',    
        'B_SQL_DB',             'B_SQL_PASS',       'B_SQL_USER',           'DATABASE_URL',
        'HOSTING_PLATFORM',     'LANG',             'PUBLIC_URL',           'RACK_ENV',
        'RAILS_ENV',            'S3_ACCESS_KEY_ID', 'S3_ARN',               'S3_BUCKET',
        'SHARED_DATABASE_URL',  'S3_PREFIX',        'S3_SECRET_ACCESS_KEY', 'STS_SESSION_TOKEN',           
        'SMTP_AUTHENTICATION',  'SMTP_DOMAIN',      'SMTP_PASSWORD',
        'SMTP_PORT',            'SMTP_SERVER',      'SMTP_TLS',             'SMTP_USER'
      ]
 
      env_var_keys.each { |env_var_key| envs[env_var_key] = app_envs[env_var_key] }
      envs
    end

    def example_email_template
      email = {}
      email['example_email_1'] = {}

      email['example_email_1']['recipient']          = "postmaster@your-app-name.gobushido.com"
      email['example_email_1']['sender']             = "sender@example.org"
      email['example_email_1']['from']               = "Example Sender <example.sender@example.org>"
      email['example_email_1']['subject']            = "Example subject"
      email['example_email_1']['body-plain']         = "Example plain body with no HTML, but with all the quoted conversations"
      email['example_email_1']['stripped-text']      = "Example stripped text, with no HTML, quotes, or signature"
      email['example_email_1']['stripped-signature'] = "Example stripped signature with no HTML"
      email['example_email_1']['body-html']          = "Example body containing <a href='http://example.org'>HTML</a>, and all of the quotes"
      email['example_email_1']['stripped-html']      = "Example body containing <a href='http://example.org'>HTML</a>, but no quotes or signature "
      email['example_email_1']['attachment-count']   = "How many attachments the email has"
      email['example_email_1']['attachment-1']       = "binary blob of file to be sent as attachment-1"
      email['example_email_1']['timestamp']          = "1323286600"

      email
    end

    def email_template_explanation
      explanation=<<-EOL
# Email format description
#
# 'name':              - name of the email template (used with `tane email 'name'`)
#   recipient          - Recipient of the message as reported by MAIL TO during SMTP chat.
#   sender             - Sender of the message as reported by MAIL FROM during SMTP chat. Note- this value may differ from From MIME header.
#   from               - Sender of the message as reported by From message header, for example Example Sender <example.sender@example.org>".
#   subject            - Subject string.
#   body-plain         - Text Version of the email. This field is always present. If the incoming message only has HTML body, this will be the text representation of it.
#   stripped-text      - Text Version of the message without quoted parts and signature block (if found).
#   stripped-signature - The Signature block stripped from the plain text message (if found).
#   body-html          - HTML version of the message, if message was multipart. Note that all parts of the message will be posted, not just text/html. For instance if a message arrives with "foo" part it will be posted as "body-foo".
#   stripped-html      - HTML version of the message, without quoted parts.
#   attachment-count   - How many attachments the message has.
#   attachment-x       - Attached file ('x' stands for number of the attachment). Attachments are handled as file uploads, encoded as multipart/form-data.
#   timestamp          - Number of second passed since January 1, 1970


EOL
    end

    def create_app
      JSON(RestClient.post("#{bushido_url}/apps.json", {:app => {:url => "https://github.com/Bushido/tane.git", :platform => "developer"}, :authentication_token => password}))
    end

    def get_app_envs(app_name)
      result = JSON(RestClient.get("#{bushido_url}/apps/#{app_name}.json", {:params => {:authentication_token => password}}))
      result["app"]["full_app_env_vars"]
    end
  end
end
