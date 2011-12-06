class Tane::Commands::Event < Tane::Commands::Base
  def self.process(args)
    event = eval(args.first)
    post(data_url, event)
  end
end
