class Tane::Commands::Claim < Tane::Commands::Base

  class << self
    def process(args)
      email = args.first
      ido_id = args[1]
      event = {'category' => 'app', 'event' => 'claimed',
        'data' => {'time' => Time.now, 'ido_id' => ido_id, 'email' => email}}
      
      post(data_url, event)
    end
    
    def help_text
      <<-EOL
Usage:

    tane claim email ido_id

Notifies the app of an App.claimed event to the locally running app when the email and ido_id are passed.

    tane claim john@example.com 6h284ah92jcj9m2sv21f
EOL
    end
  end

end
