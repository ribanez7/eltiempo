module Eltiempo
  class Options
    include Eltiempo::Utils

    @default_starts = nil
    @default_until = nil

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

      attr_writer :default_starts, :default_until

      # Return the default ending time.
      #
      # @example Reporter.default_until #=> <Date>
      #
      def default_until
        ::Eltiempo::Utils.normalize_time determine_default_until
      end

      # private
      def determine_default_until
        case @default_until
        when String
          ::Eltiempo::Utils.parse_time(@default_until)
        when Proc
          @default_until.call
        else
          @default_until
        end
      end

      # Return the default starting time.
      #
      # @example Reporter.default_starts #=> <Date>
      #
      def default_starts
        ::Eltiempo::Utils.normalize_time determine_default_starts
      end

      # private
      def determine_default_starts
        case @default_starts
        when String
          ::Eltiempo::Utils.parse_time(@default_starts)
        when Proc
          @default_starts.call
        when nil
          ::Eltiempo::Utils.current_time
        else
          @default_starts
        end
      end

      def merge(opts = {})
        new(default_options).merge(opts)
      end

      def default_options
        {
          until: default_until
        }
      end
    end

    def_option :municipality
    def_option :starts
    def_option :until
    def_option :between
    def_option :day
    def_option :week

    def initialize(opts = {})
      defaults = {
        municipality: nil,
        starts:       nil,
        until:        nil,
        day:          nil,
        week:         nil
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

    def starts=(time)
      @starts = normalize_time(as_time(time)) || default_starts
    end

    def until=(time)
      @until = normalize_time(as_time(time)) || default_until
    end

    def day=(days)
      @day = nested_map_arg(days) { |d| day_number!(d) }
    end

    def week=(weeks)
      @week = map_arg(weeks) { |w| assert_week(w) }
    end

    def between=(range)
      @between = range
      self[:starts] = range.first unless self[:starts]
      self[:until] = range.last unless self[:until]
    end

    def municipality=(place)
      @municipality = place
    end

    def inspect
      "#<#{self.class} #{to_h.inspect}>"
    end

    def start_time
      time = starts || default_starts

      time
    end

    private

      def default_starts
        self.class.default_starts
      end

      def default_until
        self.class.default_until
      end

      def nested_map_arg(arg, &block)
        case arg
        when Hash
          arg.each_with_object({}) do |(k, v), hash|
            hash[yield k] = [*v]
          end
        else
          map_arg(arg, &block)
        end
      end

      def map_arg(arg, &block)
        return nil unless arg

        Array(arg).map(&block)
      end

      def map_days(arg)
        map_arg(arg) { |d| day_number!(d) }
      end

      def assert_week(week)
        assert_range_includes(1..::Eltiempo::Utils::MAX_WEEKS_IN_YEAR, week, :absolute)
      end

      def assert_range_includes(range, item, absolute = false)
        test = absolute ? item.abs : item
        raise ConfigurationError, "Out of range: #{range.inspect} does not include #{test}" unless range.include?(test)

        item
      end
  end
end
