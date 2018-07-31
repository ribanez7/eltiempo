require 'test_helper'

module Eltiempo
  class ReporterTest < Minitest::Test
    def setup
      @reporter = Reporter.new
    end

    def test_after_initialization_it_loads_its_dependencies
      assert_instance_of Eltiempo::HttpClient, @reporter.data
      assert_instance_of Eltiempo::Options, @reporter.default_options
      observer = @reporter.instance_eval { @observer_peers }.keys.first
      assert_instance_of Eltiempo::Observers::ResultsReporter, observer
    end

    def test_chainable_module_is_mixed_in
      assert_includes @reporter.class.ancestors, Eltiempo::Chainable
    end

    def test_calling_to_h_brings_the_options_hash
      assert_equal @reporter.to_h, @reporter.default_options.to_h
    end

    def test_options_are_chainable_via_the_reporter
      tomorrow = Date.tomorrow
      tomorrow_plus_two = tomorrow + 2.days
      reporter = Reporter.new.start(tomorrow)
                             .until(tomorrow_plus_two)
                             .operation(:max)
                             .municipality('Terrassa')
      assert_equal reporter.to_h, {
        start: tomorrow,
        until: tomorrow_plus_two,
        operation: :max,
        municipality: 'Terrassa'
      }
    end

    def test_when_supplied_all_options_the_observer_fires_the_dump_method
      pattern = /Results for Terrassa, today:\n\d{1,2}° \/ \d{1,2}°\n/
      assert_output(pattern) do
        @reporter.municipality('Terrassa')
      end
    end
  end
end
