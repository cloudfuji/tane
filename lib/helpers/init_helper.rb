class Tane::Helpers::Init
  include Tane::Helpers

  class << self
    def initialize_app
      term.say "Initializing a local Bushido app for this rails app..."
      make_app_bushido_dir
      save_envs
      save_emails
      term.say "Finished successfully! Check out .bushido/tane.yml for the env vars if you care, or .bushido/emails.yml to create email templates to test with"
    end

    # TODO: Replace envs_template with values retrieved from Bushido side
    def save_envs
      if File.exists?('.bushido/tane.yml')
        if not term.agree('.bushido/tane.yml already exists! Are you sure you want to overwrite it?')
          return
        end
      end

      File.open('.bushido/tane.yml', 'w') { |file| file.puts YAML.dump(envs_template) }
    end

    # TODO: Replace email_template with a template that has every possible field
    def save_emails
      if File.exists?('.bushido/emails.yml')
        if not term.agree('.bushido/emails.yml already exists! Are you sure you want to overwrite it?')
          return
        end
      end

      File.open('.bushido/emails.yml', 'w') { |file| file.puts YAML.dump(emails_template) }
    end

    def envs_template
      envs = {}
      envs['APP_TLD']              = 'bushi.do'
      envs['BUNDLE_WITHOUT']       = 'development:test'
      envs['BUSHIDO_APP']          = 'wandering-challenge-78'
      envs['BUSHIDO_APP_KEY']      = '48b47aa0-f11c-012e-7e31-080027706aa2'
      envs['BUSHIDO_DOMAIN']       = 'wandering-challenge-78.bushi.do'
      envs['BUSHIDO_EVENTS']       = '[]'
      envs['BUSHIDO_HOST']         = 'noshido.com'
      envs['BUSHIDO_NAME']         = 'wandering-challenge-78'
      envs['BUSHIDO_PROJECT_NAME'] = 'mockr'
      envs['BUSHIDO_SALT']         = 'CwN4jQJOrbXFf378jLT5pKOTMndkRBSla0orkpTU7SphN96LpcSD2q03jAl0ikby'
      envs['BUSHIDO_SUBDOMAIN']    = 'wandering-challenge-78'
      envs['B_SQL_DB']             = 'mockr_30'
      envs['B_SQL_PASS']           = 'vagrant'
      envs['B_SQL_USER']           = 'vagrant'
      envs['DATABASE_URL']         = 'postgres://hkricsmbsg:DpcE6yS-Wx-W48jC4o-O@ec2-107-22-249-232.compute-1.amazonaws.com/hkricsmbsg'
      envs['HOSTING_PLATFORM']     = 'bushido'
      envs['LANG']                 = 'en_US.UTF-8'
      envs['PUBLIC_URL']           = 'http://wandering-challenge-78.noshido.com/'
      envs['RACK_ENV']             = 'development'
      envs['RAILS_ENV']            = 'development'
      envs['S3_ACCESS_KEY_ID']     = 'AKIAJ6QKIWRXIJQKROZA'
      envs['S3_ARN']               = 'arn:aws:iam::853820356859:user/wandering-challenge-78'
      envs['S3_BUCKET']            = 'bulk.bushido'
      envs['S3_PREFIX']            = 'wandering-challenge-78'
      envs['S3_SECRET_ACCESS_KEY'] = 'QC2pNo66ZbwBDxstu6/ngRPHzGnPZSxtOmyTN5oj'
      envs['SHARED_DATABASE_URL']  = 'postgres://hkricsmbsg:DpcE6yS-Wx-W48jC4o-O@ec2-107-22-249-232.compute-1.amazonaws.com/hkricsmbsg'
      envs['SMTP_AUTHENTICATION']  = 'plain'
      envs['SMTP_DOMAIN']          = 'wandering-challenge-78.bushi.do'
      envs['SMTP_PASSWORD']        = 'example'
      envs['SMTP_PORT']            = '587'
      envs['SMTP_SERVER']          = 'smtp.gmail.com'
      envs['SMTP_TLS']             = 'true'
      envs['SMTP_USER']            = 'example@wandering-challenge-78.bushi.do'
      envs
    end

    def emails_template
      email = {}
      email['example_email_1'] = {}

      email['example_email_1']['from']   = 'Example Sender <example@example.org>'
      email['example_email_1']['sender'] = 'sender@example.org'
      email['example_email_1']['to']     = 'recipient@example.org'
      email['example_email_1']['cc']     = ['cc-1@example.org', 'cc-2@example.org']
      email['example_email_1']['body']   = 'example email body'
      email
    end
  end
end
