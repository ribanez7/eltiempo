require 'test_helper'

module Eltiempo
  class HttpClientTest < Minitest::Test
    def setup
      @client = HttpClient.new
    end

    def test_does_just_one_call_to_get_places_database
      assert_nil @client.instance_eval { @places }
      @client.place('Sallent')
      refute_nil @client.instance_eval { @places }
    end

    def test_adds_localidad_param_once_places_db_is_in_memory
      assert_nil @client.params[:localidad]

      @client.place('Ripollet')
      refute_nil @client.params[:localidad]
    end

    def returns_an_xml_as_a_string_when_place_is_found
      assert_match /<\?xml version="1\.0" encoding="UTF-8" \?>/,
                   @client.place('Rellinars')
    end

    def test_raises_proper_error_when_place_not_found
      assert_raises(PlaceNotFoundError) do
        @client.place('unix')
      end
    end
  end
end
