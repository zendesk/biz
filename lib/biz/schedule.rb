module Biz
  class Schedule

    include Adamantium

    def initialize(&block)
      @configuration = Configuration.new(&block)
    end

    def periods
      Periods.new(self)
    end

    def intervals
      configuration.work_hours.flat_map { |weekday, hours|
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
      }.sort_by(&:start_time)
    end

    def holidays
      configuration.holidays.map { |date| Holiday.new(date, time_zone) }
    end

    def time_zone
      TZInfo::Timezone.get(configuration.time_zone)
    end

    memoize :periods,
            :intervals,
            :holidays,
            :time_zone

    protected

    attr_reader :configuration

  end
end
