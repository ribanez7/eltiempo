require 'eltiempo/observers/options_observer'

module Eltiempo
  module Observers
    class ResultsReporter < OptionsObserver
      def update(reporter)
        options = reporter.default_options
        return unless validates?(options)

        reporter.place(options[:municipality])
        reporter.calculations = Eltiempo::Calculations.new(reporter.metrics.to_s)
        reporter.dump
      end

      private

        def validates?(options)
          [
            options[:start],
            options[:until],
            options[:municipality],
            options[:operation]
          ].all?
        end
    end
  end
end
