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
          banner += Tane::Commands.command_list_and_help

          opts.banner = banner

          opts.separator ""
          opts.separator "Specific options:"

          # Mandatory argument.
          global_options.each do |option|
            opts.on(option[:name].to_s, *option[:args]) do |value|
              options.send("#{option[:name]}=", value)
            end
          end
          options.send("help_text=", opts.help())
          opts.parse!(args)
          return options
        end
      end
    end
  end
end
