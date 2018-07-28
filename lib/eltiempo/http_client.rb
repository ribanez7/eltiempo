require 'http'
require 'ox'

module Eltiempo
  class HttpClient
    # TODO: define here the connection
    CLIENT = 'http://api.tiempo.com/index.php'.freeze
    BASE_PLACE_PATH = [:report, :location, :data].freeze

    attr_accessor :municipality, :params

    def initialize
      @params = {
        api_lang: :es,
        division: 102,
        affiliate_id: :zdo2c683olan
      }
    end

    def get_place(place)
      xml = HTTP.get(CLIENT, params: params).to_s
      xml_object = Ox.load(xml, mode: :hash_no_attrs)
      place_hash = xml_object.dig(*BASE_PLACE_PATH)
                             .find do |city|
                               city[:name].match?(/\A#{place}\z/i)
                             end
      municipality = URI.decode_www_form(
        URI.parse(place_hash[:url]).query
      ).to_h['localidad']

      @params = params.merge(localidad: municipality)
    end
  end
end
