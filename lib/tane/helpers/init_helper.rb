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

      term.say "Finished successfully! Check out .bushido/tane.yml for the env vars if you care, or .bushido/emails.yml to create email templates to test with"
    end

    def update_app
      save_envs(get_app_envs(bushido_envs['BUSHIDO_NAME']))
    end

    # TODO: Replace envs_template with values retrieved from Bushido side
    def save_envs(env_vars)
      if File.exists?('.bushido/tane.yml')
        if not term.agree('.bushido/tane.yml already exists! Are you sure you want to overwrite it?')
          return
        end
      end

      File.open('.bushido/tane.yml', 'w+') { |file| file.puts YAML.dump(envs_template(env_vars)) }
    end

    # TODO: Replace email_template with a template that has every possible field
    def save_emails
      if File.exists?('.bushido/emails.yml')
        if not term.agree('.bushido/emails.yml already exists! Are you sure you want to overwrite it?')
          return
        end
      end

      File.open('.bushido/emails.yml', 'w') { |file| file.puts email_template_explanation; file.puts YAML.dump(emails_template) }
    end

    def envs_template(app_envs)
      envs = {}
      envs['APP_TLD']              = app_envs['APP_TLD']
      envs['BUNDLE_WITHOUT']       = app_envs['BUNDLE_WITHOUT']
      envs['BUSHIDO_APP']          = app_envs['BUSHIDO_APP']
      envs['BUSHIDO_APP_KEY']      = app_envs['BUSHIDO_APP_KEY']
      envs['BUSHIDO_DOMAIN']       = app_envs['BUSHIDO_DOMAIN']
      envs['BUSHIDO_EVENTS']       = app_envs['BUSHIDO_EVENTS']
      envs['BUSHIDO_HOST']         = app_envs['BUSHIDO_HOST']
      envs['BUSHIDO_NAME']         = app_envs['BUSHIDO_NAME']
      envs['BUSHIDO_PROJECT_NAME'] = app_envs['BUSHIDO_PROJECT_NAME']
      envs['BUSHIDO_SALT']         = app_envs['BUSHIDO_SALT']
      envs['BUSHIDO_SUBDOMAIN']    = app_envs['BUSHIDO_SUBDOMAIN']
      envs['B_SQL_DB']             = app_envs['B_SQL_DB']
      envs['B_SQL_PASS']           = app_envs['B_SQL_PASS']
      envs['B_SQL_USER']           = app_envs['B_SQL_USER']
      envs['DATABASE_URL']         = app_envs['DATABASE_URL']
      envs['HOSTING_PLATFORM']     = app_envs['HOSTING_PLATFORM']
      envs['LANG']                 = app_envs['LANG']
      envs['PUBLIC_URL']           = app_envs['PUBLIC_URL']
      envs['RACK_ENV']             = app_envs['RACK_ENV']
      envs['RAILS_ENV']            = app_envs['RAILS_ENV']
      envs['S3_ACCESS_KEY_ID']     = app_envs['S3_ACCESS_KEY_ID']
      envs['S3_ARN']               = app_envs['S3_ARN']
      envs['S3_BUCKET']            = app_envs['S3_BUCKET']
      envs['S3_PREFIX']            = app_envs['S3_PREFIX']
      envs['S3_SECRET_ACCESS_KEY'] = app_envs['S3_SECRET_ACCESS_KEY']
      envs['SHARED_DATABASE_URL']  = app_envs['SHARED_DATABASE_URL']
      envs['SMTP_AUTHENTICATION']  = app_envs['SMTP_AUTHENTICATION']
      envs['SMTP_DOMAIN']          = app_envs['SMTP_DOMAIN']
      envs['SMTP_PASSWORD']        = app_envs['SMTP_PASSWORD']
      envs['SMTP_PORT']            = app_envs['SMTP_PORT']
      envs['SMTP_SERVER']          = app_envs['SMTP_SERVER']
      envs['SMTP_TLS']             = app_envs['SMTP_TLS']
      envs['SMTP_USER']            = app_envs['SMTP_USER']
      envs
    end

    def emails_template
      email = {}
      email['example_email_1'] = {}

      email['example_email_1']['recipient']          = "postmaster@your-app-name.gobushido.com"
      email['example_email_1']['sender']             = "sender@example.org"
      email['example_email_1']['from']               = "Example Sender <example.sender@example.org"
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
