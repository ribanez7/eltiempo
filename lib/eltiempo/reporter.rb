require 'ox'
require 'observer'
require 'eltiempo/observers/results_reporter'
require 'eltiempo/http_client'
require 'eltiempo/chainable'
require 'eltiempo/errors'

module Eltiempo
  class Reporter
    extend Forwardable
    include Chainable
    include Observable

    attr_reader :default_options, :data
    attr_accessor :calculations

    def_delegators :@default_options, :operation
    def_delegators :@calculations, :today, :av_max, :av_min
    def_delegators :@data, :place, :metrics

    REPORTS = {
      max:     {command: :av_max, message: 'average maximum (7 days)'},
      min:     {command: :av_min, message: 'average minimum (7 days)'},
      general: {command: :today, message: 'today'}
    }.freeze

    class << self
      def new(options = {})
        return options if options.is_a?(self)
        super
      end
    end

    def initialize(opts = {})
      Observers::ResultsReporter.new(self)
      @default_options = Eltiempo::Options.new(opts)
      @data = Eltiempo::HttpClient.new
      changed
      notify_observers(self)
    end

    def dump
      action = REPORTS[operation]
      output = <<~OUTPUT
        Results for #{@default_options[:municipality]}, #{action[:message]}:
        #{self.send(action[:command])}
      OUTPUT
      puts output
    end

    def to_hash
      default_options.to_hash
    end
    alias to_h to_hash
  end
end
