class Tane::Commands::Claim < Tane::Commands::Base
  def self.process(args)
    email = args.first
    ido_id = args[1]
    event = {'category' => 'app', 'event' => 'claimed',
      'data' => {'time' => Time.now, 'ido_id' => ido_id, 'email' => email}}

    post(data_url, event)
  end
end
