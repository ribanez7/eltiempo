require 'eltiempo/options'
require 'eltiempo/refinements/array_concat'

module Eltiempo
  module Chainable
    using Eltiempo::Refinements::ArrayConcat

    # TODO: define here the gem api:
    #
    # Eltiempo.municipality('Gavà').today
    # Eltiempo.today.municipality('Gavà')
    # Eltiempo.average_maximum.municipality('Gavà')
    # Eltiempo.average_minimum.municipality('Gavà')
    # Eltiempo.average_maximum.current_week.municipality('Gavà')
    #
    # This methods will branch or merge the options to use.
    # The array_concat refinement will allow us to sum days.
    #

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
