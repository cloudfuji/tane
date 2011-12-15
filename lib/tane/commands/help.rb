class Tane::Commands::Help < Tane::Commands::Base
  def self.process(args)
    puts opts.help_text
  end
end
