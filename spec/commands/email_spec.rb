require "spec_helper"

describe Tane::Commands::Email do

  describe ".process" do
    it "should send email" do
      args = ['foo']
      Tane::Commands::Email.should_receive(:send_email)

      Tane::Commands::Email.process(args)
    end
  end

  describe ".send_email" do
    it "should display a message and exit if email template is not available" do
      Tane::Commands::Email.should_receive(:render_email).and_return(nil)

      Tane::Commands::Email.term.should_receive(:say)

      expect {
        Tane::Commands::Email.send_email('invalid_email_template')
      }.to raise_error(SystemExit)
    end

    it "should post to mail url of the local app if email template is available" do
      email_template_name = "valid_email_template_name"
      email_template = "valid_email_template"
      bushido_mail_url = Tane::Commands::Email.mail_url
      
      Tane::Commands::Email.should_receive(:render_email)
        .with(email_template_name)
        .and_return(email_template)
      
      Tane::Commands::Email.should_receive(:post)
        .with(bushido_mail_url, email_template)

      Tane::Commands::Email.send_email(email_template_name)
    end
  end

  describe ".render_email" do
    it "should load the email template specified" do
      valid_email_template_name = "valid_email_template"
      File.should_receive(:read).
        with(Tane::Commands::Email.email_template_file_path).
        and_return("valid_email_template: this is a dummy template")

      Tane::Commands::Email.render_email(valid_email_template_name)
    end
  end

end
