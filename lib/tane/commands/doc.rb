class Tane::Commands::Doc < Tane::Commands::Base

  ENV['RACK_ENV'] = "development"
  
  require 'sinatra'
  require 'bushido'
  
  class DocApp < ::Sinatra::Base
    set :views, File.expand_path("../../../../vendor", __FILE__)

    get "/" do
      erb :index
    end

    post "/tane_eval" do
      eval("#{params[:command]}")
    end

    post "/tane_exec" do
      system("#{params[:command]}")
    end
  end
  
  class << self
    def process(args)
      DocApp.run!
    end
  end

end
