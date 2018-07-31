require 'test_helper'

module Eltiempo
  class CalculationsTest < Minitest::Test
    def setup
      city_data = File.read(
        File.expand_path(
          File.join('test', 'fixtures', 'xml_rubi.xml')
        )
      )
      @calculator = Calculations.new(city_data)
    end

    def test_given_an_xml_db_it_extracts_and_calculates_max_temperature
      assert_equal @calculator.av_max, '36°'
    end

    def test_given_an_xml_db_it_extracts_and_calculates_min_temperature
      assert_equal @calculator.av_min, '24°'
    end

    def test_given_an_xml_db_it_extracts_and_calculates_today_temperature
      assert_equal @calculator.today, '35° / 22°'
    end
  end
end
