module Biz
  class Configuration

    include Memoizable

    def initialize
      @raw = Raw.new.tap do |raw| yield raw end
    end

    def intervals
      raw.business_hours.flat_map { |weekday, hours|
        weekday_intervals(weekday, hours)
      }.sort_by(&:start_time)
    end

    def holidays
      raw.holidays.map { |date| Holiday.new(date, time_zone) }
    end

    def time_zone
      TZInfo::TimezoneProxy.new(raw.time_zone)
    end

    protected

    attr_reader :raw

    private

    def weekday_intervals(weekday, hours)
      hours.map { |start_timestamp, end_timestamp|
        Interval.new(
          WeekTime.start(
            DayOfWeek.from_symbol(weekday).start_minute +
              DayTime.from_timestamp(start_timestamp).day_minute
          ),
          WeekTime.end(
            DayOfWeek.from_symbol(weekday).start_minute +
              DayTime.from_timestamp(end_timestamp).day_minute
          ),
          time_zone
        )
      }
    end

    memoize :intervals,
            :holidays

    Raw = Struct.new(:business_hours, :holidays, :time_zone)

  end
end
