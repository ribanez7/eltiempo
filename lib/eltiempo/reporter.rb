require 'ox'
require 'json'
require 'eltiempo/http_client'
require 'eltiempo/chainable'
require 'eltiempo/errors'

module Eltiempo
  class Reporter
    extend Forwardable
    include Chainable

    attr_reader :default_options, :data_persisted

    class << self
      def new(options = {})
        return options if options.is_a?(self)
        super
      end

      def dump(obj)
        return nil if obj.nil?

        # TODO: create the dumper, id. est. the printer logic
        raise SerializationError, "Object was supposed to be a #{self}, but was a #{obj.class}. -- #{obj.inspect}"
      end
    end

    def initialize(opts = {})
      @default_options = Eltiempo::Options.new(opts)
      @data_persisted  = false
    end

    def dump
      grab_data unless data_persisted
      self.class.dump(self)
    end

    def grab_data
      return unless @default_options[:municipality]
    end

    # Returns a hash of the options used to create the reporter
    #
    # @return [Hash] hash of reporter options
    #
    def to_hash
      default_options.to_hash
    end
    alias to_h to_hash
  end
end
