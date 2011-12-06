class Tane::Commands::Exec < Tane::Commands::Base
  def self.process(args)

    bushido_envs.each_pair do |key, value|
      ENV[key] = value
    end

    Dir.chdir(Dir.pwd) do |dir|
      command = args.join(' ')
      puts command
      exec command
    end
  end
end
