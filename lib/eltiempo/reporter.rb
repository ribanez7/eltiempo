require 'ox'
require 'json'
require 'yaml'
require 'eltiempo/http_client'
require 'eltiempo/chainable'
require 'eltiempo/errors'

module Eltiempo
  class Reporter
    extend Forwardable
    include Chainable

    attr_reader :default_options
    def_delegator :@default_options, :starts
    def_delegator :@default_options, :until

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
    end

    # Returns a hash of the options used to create the reporter
    #
    # @return [Hash] hash of reporter options
    #
    def to_hash
      default_options.to_hash
    end
    alias to_h to_hash

    # Returns json string of options used to create the reporter
    #
    # @return [String] json of reporter options
    #
    def to_json(*args)
      JSON.dump(to_hash, *args)
    end

    # Returns options used to create the reporter in YAML format
    #
    # @return [String] YAML-formatted reporter options
    #
    def to_yaml(*args)
      YAML.dump(JSON.parse(to_json(*args)))
    end
  end
end
