class Tane::Commands::Event < Tane::Commands::Base

  class << self
    def process(args)
      event = {'category' => args.first, 'event' => args[1], 'data' => eval(args[2])}
      puts event
      post(data_url, event)
    end

    def help_text
      <<-EOL
Usage:

    tane event event_category event_name data_hash
    
Notifies the local app of an event. The event category, event name are to be passed along with the data. The data is in the form of a ruby hash with the keys as strings (not symbols!). The following is an example.
EOL
    end
  end

end
