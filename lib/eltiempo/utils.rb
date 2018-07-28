module Eltiempo
  module Utils
    module_function

    MONTHS = ::Date::MONTHNAMES

    DAYS = ::Date::DAYNAMES

    MAX_HOURS_IN_DAY = 24
    MAX_DAYS_IN_YEAR = 366
    MAX_WEEKS_IN_YEAR = 53
    MAX_DAYS_IN_MONTH = 31

    def as_time(time)
      return nil unless time

      if time.is_a?(String)
        parse_time(time)
      elsif time.is_a?(ActiveSupport::TimeWithZone)
        time
      elsif time.respond_to?(:to_time)
        time.to_time
      else
        Array(time).flat_map { |d| as_time(d) }
      end
    end

    def as_date(time)
      as_time(time).to_date
    end

    def parse_time(*args)
      ::Time.zone.nil? ? ::Time.parse(*args) : ::Time.zone.parse(*args)
    end

    def current_day
      as_date(::Time.current)
    end
  end
end
