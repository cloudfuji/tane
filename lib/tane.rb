require "tane/version"
require "helpers"
require 'ostruct'
require "optparse"
require 'awesome_print'
require 'highline'

# Load all the available commands
$commands = []
Dir.glob("./lib/commands/*.rb").each do |command|
  $commands << command.split("/").last.split('.rb').first
end

# Mark the commands for autoload (load-on-demand)
module Tane
  module Commands
    $commands.each do |command|
      autoload command.capitalize.to_sym, "commands/#{command}"
    end
  end
end

$helpers = []
Dir.glob("./lib/helpers/*.rb").each do |helper|
  $helpers << helper.split("/").last.split('_helper.rb').first
end

# Mark the commands for autoload (load-on-demand)
module Tane
  module Helpers
    $helpers.each do |helper|
      autoload helper.capitalize.to_sym, "helpers/#{helper}_helper"
    end
  end
end

module Tane
  class Parser
    class << self

      def global_options
        @global_options ||= []
      end

      def global_option(name, *args)
        self.global_options << {:name => name, :args => args}
      end

      def parse(args)
        # The options specified on the command line will be collected in *options*.
        # We set default values here.
        options = OpenStruct.new
        options.scheme = "http"
        options.host = "localhost"
        options.port = 3000
        options.inplace = false
        options.encoding = "utf8"
        options.transfer_type = :auto
        options.verbose = false

        global_option :port,    '-p', '--port PORT',     Integer, "The port your local Bushido app is running on"
        global_option :host,    '-n', '--host HOST',     String,  "The hostname where your local Bushido app is running"
        global_option :scheme,  '-s', '--scheme SCHEME', String,  "Either http or https, whichever protocol your local Bushido app is using"
        global_option :verbose, '-V', '--verbose',                "Output a lot of noise"

        opts = OptionParser.new do |opts|
          banner  = "Usage: tane command [options]\n"
          banner += "\n"
          banner += "The commands I know are:\n"
          ($commands - ["base", "app"]).each do |command|
            banner += "  #{command}\n"
          end

          opts.banner = banner

          opts.separator ""
          opts.separator "Specific options:"

          # Mandatory argument.
          global_options.each do |option|
            opts.on(option[:name].to_s, *option[:args]) do |value|
              options.send("#{option[:name]}=", value)
            end
          end

          opts.parse!(args)
          return options
        end
      end
    end
  end
end


options = Tane::Parser.parse(ARGV)
command = ARGV.shift.strip rescue 'help'
command = 'help' if command == ''

eval("Tane::Commands::#{command.capitalize}").fire(options, ARGV)
