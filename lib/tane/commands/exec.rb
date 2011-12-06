class Tane::Commands::Exec < Tane::Commands::Base
  def self.process(args)
    ap bushido_envs
    bushido_envs.each_pair do |key, value|
      ENV[key] = value
    end

    exec args.join(' ')
  end
end
