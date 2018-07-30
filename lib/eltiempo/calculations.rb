require 'ox'
require 'eltiempo/refinements/average'

module Eltiempo
  class Calculations
    using Eltiempo::Refinements::Average

    attr_reader :db

    def initialize(db)
      @db = Ox.load(db, mode: :hash)
    end

    def today
      "#{today_max}° / #{today_min}°"
    end

    def av_max
      "#{week_maxs.average}°"
    end

    def av_min
      "#{week_mins.average}°"
    end

    private

      def document_root
        db.dig(:report, :location)
      end

      def max
        document_root[3].dig(:var, :data, :forecast)
      end

      def min
        document_root[2].dig(:var, :data, :forecast)
      end

      def today_max
        max[0][0][:value].to_i
      end

      def today_min
        min[0][0][:value].to_i
      end

      def week_maxs
        max.flat_map { |a| a.first[:value].to_i }
      end

      def week_mins
        min.flat_map { |a| a.first[:value].to_i }
      end
  end
end
