require "spec_helper"

describe Tane::Commands::Email do

  subject { Tane::Commands::Email }
  
  describe ".process" do
    it "should send email if command is 'tane email template_name'" do
      args = ["valid_template"]
      subject.should_receive(:send_email).with("valid_template")

      subject.process(args)
    end

    it "should list email if commad is 'tane email'" do
      args = []
      subject.should_receive(:list_email_templates)

      subject.process(args)
    end
  end

  describe ".send_email" do

    describe "if email template is not available" do
      it "should display a message and exit " do
        subject.should_receive(:render_email).and_return(nil)
        subject.term.should_receive(:say).at_least(1)
        
        expect {
          subject.send_email('invalid_email_template')
        }.to raise_error(SystemExit)
      end

      it "should list available email templates" do
        subject.should_receive(:render_email).and_return(nil)
        subject.term.should_receive(:say).at_least(1)
        subject.should_receive(:list_email_templates)

        expect {
          subject.send_email('invalid_email_template')
        }.to raise_error(SystemExit)
      end
    end

    it "should post to mail url of the local app if email template is available" do
      email_template_name = "valid_email_template_name"
      email_template = "valid_email_template"
      cloudfuji_mail_url = subject.mail_url
      
      subject.should_receive(:render_email)
        .with(email_template_name)
        .and_return(email_template)
      
      subject.should_receive(:post)
        .with(cloudfuji_mail_url, email_template)

      subject.send_email(email_template_name)
    end
  end

  describe ".render_email" do
    it "should load the email template specified" do
      valid_email_template_name = "valid_email_template"
      File.should_receive(:read).
        with(subject.email_template_file_path(valid_email_template_name)).
        and_return("valid_email_template: this is a dummy template")

        subject.render_email(valid_email_template_name)
    end
  end

end
