require 'launchy'

class Tane::Commands::Open < Tane::Commands::Base
  class << self
    def process(args)
      timeout = opts.timeout || 4

      started = try_for(:seconds => timeout) do
        begin
          RestClient.get("http://localhost:3000/")
          true
        rescue => e
          false
        end
      end

      Launchy.open("http://localhost:3000/") if started
    end

    def help_text
      <<-EOL
Usage:

    tane open

Waits until there's a webserver running at port 3000 and then opens the browser to it.

    tane open
EOL
    end
  end

end
