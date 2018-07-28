require 'eltiempo/options'

module Eltiempo
  module Chainable
    # TODO: define here the gem api:
    #
    # Eltiempo.municipality('Gavà').today
    # Eltiempo.today.municipality('Gavà')
    # Eltiempo.average_maximum.municipality('Gavà')
    # Eltiempo.average_minimum.municipality('Gavà')
    # Eltiempo.municipality('Gavà')
    #
    # This methods will branch or merge the options to use.
    #

    def today
      branch default_options
    end

    def average_maximum
      branch default_options.merge(operation: :max)
    end

    def average_minimum
      branch default_options.merge(operation: :min)
    end

    def municipality(place)
      merge(municipality: place)
    end

    def operation(operation)
      merge(operation: operation)
    end

    def start(dtstart)
      merge(start: ::Eltiempo::Utils.as_date(dtstart))
    end

    def until(dtend)
      merge(until: ::Eltiempo::Utils.as_date(dtend))
    end

    def between(range)
      merge(between: range)
    end

    def merge(other = {})
      branch default_options.merge(other)
    end

    def branch(options)
      Eltiempo::Reporter.new(options)
    end

    def default_options
      @default_options ||= Eltiempo::Options.new
    end
  end
end
