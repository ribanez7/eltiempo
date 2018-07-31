# Eltiempo.municipality('Gavà').today
# Eltiempo.today.municipality('Gavà')
# Eltiempo.average_maximum.municipality('Gavà')
# Eltiempo.average_minimum.municipality('Gavà')
# Eltiempo.municipality('Gavà')
require 'test_helper'
require 'timecop'

module Eltiempo
  class OptionsTest < Minitest::Test
    include Utils

    def setup
      ::Timecop.freeze(Time.now)
      @opts = Options.new
      @defaults = {
        operation: :general,
        start: Date.today,
        until: Date.today
      }
    end

    def test_a_newly_generated_options_objects_has_default_values
      assert_equal @opts.to_h, @defaults
      assert_instance_of ::Eltiempo::Options, @opts
    end

    def test_options_inspection_is_a_clear_and_clean_string
      expected = <<~INSPECT.delete("\n")
        #<Eltiempo::Options {
        :operation=>:general, 
        :start=>#{Date.today.inspect}, 
        :until=>#{Date.today.inspect}
        }>
      INSPECT
      assert_match expected, @opts.inspect
    end

    def test_default_start
      assert_equal as_date(@opts.start), Date.today
    end

    def test_default_until
      assert_equal as_date(@opts.until), Date.today
    end

    def test_default_operation
      assert_equal @opts.operation, :general
    end

    def test_options_can_be_changed_as_a_hash_or_as_an_object
      start_opt = Date.tomorrow
      until_opt = Date.tomorrow + 5.days
      operation = :max

      @opts[:start] = start_opt
      @opts[:until] = until_opt
      @opts[:operation] = operation
      assert_equal @opts.to_h, {start: start_opt, until: until_opt, operation: operation}

      @opts.start = Date.today
      @opts.until = Date.today
      @opts.operation = :general
      assert_equal @opts.to_h, @defaults
    end

    def test_between_option_sets_until_and_start
      @opts.between = ('20180101'.to_date)..('20180201'.to_date)
      assert_equal @opts.start, '20180101'.to_date
      assert_equal @opts.until, '20180201'.to_date
    end

    def test_municipality_behaves_as_all_other_options
      @opts.municipality = 'Terrassa'
      assert_equal @opts.municipality, 'Terrassa'

      @opts[:municipality] = 'Sabadell'
      assert_equal @opts[:municipality], 'Sabadell'
    end
  end
end
