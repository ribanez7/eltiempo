require 'active_support'
require 'active_support/core_ext/object'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/date'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_time'

require 'eltiempo/utils'
require 'eltiempo/calculations'
require 'eltiempo/chainable'
require 'eltiempo/reporter'
require 'eltiempo/version'

module Eltiempo
  extend Chainable

  class << self
    # Create a new reporter from given options
    # An alias to {Eltiempo::Reporter.new}
    # it prints to STDOUT the results if all the
    # needed options are provided.
    #
    # @param options [Hash] reporting options
    #
    # @example
    #   Eltiempo.reporter(municipality: 'Gavà')
    #   Eltiempo.r(municipality: 'Gavà')
    #
    # @return [Eltiempo::Reporter]
    #
    def reporter(options = {})
      branch(options)
    end
    alias r reporter
  end
end
