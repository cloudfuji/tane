class Tane::Commands::Event < Tane::Commands::Base
  def self.process(args)
    event = {'category' => args.first, 'event' => args[1], 'data' => eval(args[2])}
    puts event
    post(data_url, event)
  end
end
