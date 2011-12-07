class Tane::Commands::Exec < Tane::Commands::Base
  def self.process(args)
    authenticate_user
    bushido_envs.each_pair do |key, value|
      ENV[key] = value
    end

    command = args.join(' ')
    exec command

  end
end
