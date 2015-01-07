module Biz
  class Schedule

    include Memoizable

    def initialize(&block)
      @configuration = Configuration.new(&block)
    end

    def periods
      Periods.new(self)
    end

    def intervals
      configuration.work_hours.flat_map { |weekday, hours|
        weekday_intervals(weekday, hours)
      }.sort_by(&:start_time)
    end

    def holidays
      configuration.holidays.map { |date| Holiday.new(date, time_zone) }
    end

    def time_zone
      TZInfo::TimezoneProxy.new(configuration.time_zone)
    end

    protected

    attr_reader :configuration

    private

    def weekday_intervals(weekday, hours)
      hours.map { |start_timestamp, end_timestamp|
        Interval.new(
          WeekTime.new(
            DayOfWeek.from_symbol(weekday).start_minute +
            DayTime.from_timestamp(start_timestamp).day_minute
          ),
          WeekTime.new(
            DayOfWeek.from_symbol(weekday).start_minute +
              DayTime.from_timestamp(end_timestamp).day_minute
          ),
          time_zone
        )
      }
    end

    memoize :periods,
            :intervals,
            :holidays

  end
end
