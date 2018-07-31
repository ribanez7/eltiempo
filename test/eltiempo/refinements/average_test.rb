require 'test_helper'

module Eltiempo
  module Refinements
    class AverageTest < Minitest::Test
      class Dummy
        using Average

        def integers_average
          [1, 2, 3, 4, 5].average
        end

        def floats_average
          [5.1, 4.6, 9.8, 20.7, 8.0].average
        end
      end

      def setup
        @mock = Dummy.new
      end

      def test_an_array_knows_how_to_calculate_integers_average
        assert_equal @mock.integers_average, 3
      end

      def test_an_array_knows_how_to_calculate_floats_average
        assert_equal @mock.floats_average, 9.64
      end
    end
  end
end
