module Eltiempo
  class Options
    include Eltiempo::Utils

    @default_start = Date.today
    @default_until = Date.today

    class << self
      def new(options = {})
        return options if options.is_a?(self)
        super
      end

      def defined_options
        @defined_options ||= []
      end

      def def_option(name)
        defined_options << name.to_sym
        attr_accessor name
        protected :"#{name}="
      end

      attr_writer :default_start, :default_until

      def default_until
        @default_until
      end

      def default_start
        @default_start
      end

      def merge(opts = {})
        new(default_options).merge(opts)
      end

      def default_options
        {
          start: default_start,
          until: default_until,
          operation: :general
        }
      end
    end

    def_option :municipality
    def_option :start
    def_option :until
    def_option :between

    def initialize(opts = {})
      defaults = {
        municipality: nil,
        start:        nil,
        until:        nil,
      }

      options = defaults.merge(opts || {})
      options.each { |(k, v)| self[k] ||= v if v }
    end

    def to_hash
      hash_pairs = self.class.defined_options.flat_map do |opt_name|
        [opt_name, send(opt_name)]
      end
      Hash[*hash_pairs].reject { |_k, v| v.nil? }
    end
    alias to_h to_hash

    def []=(option, val)
      send(:"#{option}=", val)
    end

    def [](option)
      send(:"#{option}")
    end

    def merge(other)
      h1 = to_hash
      h2 = other.to_hash

      self.class.new(h1.merge(h2))
    end

    def start=(date)
      @start = as_date(date) || default_start
    end

    def until=(date)
      @until = as_date(date) || default_until
    end

    def between=(range)
      @between = range
      self[:start] = range.first unless self[:start]
      self[:until] = range.last unless self[:until]
    end

    def municipality=(place)
      @municipality = place.to_s
    end

    def operation=(operation)
      @operation = operation.to_sym
    end

    def inspect
      "#<#{self.class} #{to_h.inspect}>"
    end

    private

      def default_start
        self.class.default_start
      end

      def default_until
        self.class.default_until
      end
  end
end
