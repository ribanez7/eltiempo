require 'test_helper'

module Eltiempo
  class UtilsTest < Minitest::Test
    include Utils

    def test_returns_current_time
      Time.freeze do
        assert_equal current_time, Time.current
      end
    end

    def test_as_time_parses_strings
      time_string = Time.now.to_s
      assert_equal as_time(time_string).class, Time
      assert_equal as_time(time_string), Time.parse(time_string)
    end

    def test_as_time_returns_unmodified_ActiveSupport_TimeWithZone_objects
      Time.use_zone("Beijing") do
        time_with_zone = Time.zone.now
        assert_equal time_with_zone.class, ActiveSupport::TimeWithZone
        assert_equal as_time(time_with_zone), time_with_zone
      end
    end

    def test_as_time_casts_to_time_if_available
      assert_equal as_time(Date.today), Date.today.to_time
    end

    def test_parse_time_is_predictable
      assert_equal parse_time("Sept 1, 2015 12:00PM"), Time.parse("Sept 1, 2015 12:00PM")
    end

    def test_parse_time_knows_how_to_use_time_zone_if_available
      Time.use_zone("Hawaii") do
        time = parse_time("Sept 1, 2015 12:00PM")
        assert_equal time.month, 9
        assert_equal time.day, 1
        assert_equal time.year, 2015
        assert_equal time.hour, 12
        assert_equal time.utc_offset, -10.hours
      end
    end
  end
end
