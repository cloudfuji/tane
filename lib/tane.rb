require "ostruct"
require "optparse"
require "awesome_print"
require "highline"
require "tane/version"
require "tane/helpers"
require "tane/parser"

# Load all the available commands
$commands = []

Dir.glob(File.dirname(__FILE__) + "/tane/commands/*.rb").each do |command|
  $commands << command.split("/").last.split('.rb').first
end

# Mark the commands for autoload (load-on-demand)
module Tane
  module Commands
    $commands.each do |command|
      autoload command.capitalize.to_sym, "tane/commands/#{command}"
    end

    class << self
      def command_list_and_help
        command_list  = "\n"
        command_list += "The commands I know are:"

        ($commands - ["app", "base"]).each do |command|
          command_list += "\n  #{command}"
        end

        command_list += "\n\n"
        command_list += "For help on any of these commands do"
        command_list += "\n\t"
        command_list += "tane help command_name"
        command_list += "\n\n"
      end

      def const_missing(name)
        puts "Unsupported command #{name.downcase}."
        puts command_list_and_help
        exit 1
      end
    end

  end
end

$helpers = []

Dir.glob(File.dirname(__FILE__) + "/tane/helpers/*.rb").each do |helper|
  $helpers << helper.split("/").last.split('_helper.rb').first
end

# Mark the commands for autoload (load-on-demand)
module Tane
  module Helpers
    $helpers.each do |helper|
      autoload helper.capitalize.to_sym, "tane/helpers/#{helper}_helper"
    end
  end
end

