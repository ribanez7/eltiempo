module Eltiempo
  module Observers
    class OptionsObserver
      def initialize(options)
        @options = options
        @options.add_observer(self)
      end
    end
  end
end
