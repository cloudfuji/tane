module Tane
  module Commands
    class Base
      include Tane::Helpers

      class << self
        def fire(opts, args)
          @opts = opts

          process(args)
        end
      end
    end
  end
end
