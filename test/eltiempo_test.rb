require "test_helper"

class EltiempoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Eltiempo::VERSION
  end

  def test_it_delegates_the_logic_to_the_reporter_main_class
    pattern = /Results for Terrassa, today:\n\d{1,2}° \/ \d{1,2}°\n/
    assert_output(pattern) do
      Eltiempo.r(municipality: 'Terrassa')
    end
  end
end
