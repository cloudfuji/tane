class Tane::Commands::Init < Tane::Commands::Base
  def self.process(args)
    if in_rails_dir?
      Tane::Helpers::Init.initialize_app
    else
      term.say("You have to be in the local rails app's root directory when running `tane init`")

      exit 1
    end
  end
end
