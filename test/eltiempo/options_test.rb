# Eltiempo.municipality('Gavà').today
# Eltiempo.today.municipality('Gavà')
# Eltiempo.average_maximum.municipality('Gavà')
# Eltiempo.average_minimum.municipality('Gavà')
# Eltiempo.municipality('Gavà')
require 'test_helper'

module Eltiempo
  class OptionsTest < Minitest::Test
    def test_a_newly_generated_options_objects_has_default_values
      defaults = {
        operation: :general,
        start: Date.today,
        until: Date.today
      }
      opts = Options.new
      assert_equal opts.to_h, defaults
      assert_instance_of ::Eltiempo::Options, opts
    end

    def test_options_inspection_is_a_clear_and_clean_string
      opts = Options.new
      expected = <<~INSPECT.delete("\n")
        #<Eltiempo::Options {
        :operation=>:general, 
        :start=>#{Date.today.inspect}, 
        :until=>#{Date.today.inspect}
        }>
      INSPECT
      assert_match expected, opts.inspect
    end
  end
end
