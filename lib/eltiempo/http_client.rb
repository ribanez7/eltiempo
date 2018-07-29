require 'http'
require 'ox'
require 'eltiempo/refinements/query_param_find'

module Eltiempo
  class HttpClient
    using Eltiempo::Refinements::QueryParamFind

    # TODO: define here the connection
    CLIENT = 'http://api.tiempo.com/index.php'.freeze
    PLACE_PATH = [:report, :location, :data].freeze

    attr_accessor :municipality, :params

    def initialize
      @params = {
        api_lang:     :es,
        division:     102,
        affiliate_id: :zdo2c683olan
      }
    end

    def place(place)
      place_hash = with_places_xml.find(&place_finder(place))
      raise PlaceNotFoundError unless place_hash
      municipality = place_hash[:url].query_param_find('localidad')
      @params = params.merge(localidad: municipality)
      self
    end

    def metrics
      raise PlaceMissingError unless params[:localidad]
      HTTP.get(CLIENT, params: metrics_params).to_s
    end

    private

      def metrics_params
        params.reject { |k, _v| k == :division }
      end

      def place_finder(place)
        lambda do |city|
          city[:name].match?(/\A#{place}\z/i)
        end
      end

      def places
        @places ||= HTTP.get(CLIENT, params: params).to_s
      end

      def with_xml(text, root_path, options)
        xml_object = Ox.load(text, options)
        Array(xml_object.dig(*root_path))
      end

      def with_places_xml
        with_xml(places, PLACE_PATH, mode: :hash_no_attrs)
      end
  end
end
