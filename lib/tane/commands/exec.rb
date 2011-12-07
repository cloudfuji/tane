class Tane::Commands::Exec < Tane::Commands::Base
  def self.process(args)
    authenticate_user
    bushido_envs.each_pair do |key, value|
      ENV[key] = value
    end

    command = args.join(' ')

    if command.empty?
      term.say("please enter a command for tane exec to run. example:")
      term.say("\t tane exec rails s")

      exit 1
    end

    exec command

  end
end
