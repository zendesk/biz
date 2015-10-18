module Biz
  class Time

    MINUTE = 60
    HOUR   = 60 * MINUTE
    DAY    = 24 * HOUR
    WEEK   = 7 * DAY

    MINUTES_IN_HOUR = 60
    HOURS_IN_DAY    = 24
    DAYS_IN_WEEK    = 7

    MINUTES_IN_DAY  = MINUTES_IN_HOUR * HOURS_IN_DAY
    MINUTES_IN_WEEK = MINUTES_IN_DAY * DAYS_IN_WEEK
    SECONDS_IN_DAY  = MINUTES_IN_DAY * 60

    BIG_BANG   = ::Time.new(-10**100)
    HEAT_DEATH = ::Time.new(10**100)

    attr_reader :time_zone

    def initialize(time_zone)
      @time_zone = time_zone
    end

    def local(time)
      time_zone.utc_to_local(time.utc)
    end

    def on_date(date, day_time)
      time_zone.local_to_utc(
        ::Time.utc(
          date.year,
          date.month,
          date.mday,
          day_time.hour,
          day_time.minute,
          day_time.second
        ),
        true
      )
    rescue TZInfo::PeriodNotFound
      next_day_second = day_time.day_second + HOUR
      if next_day_second > SECONDS_IN_DAY
        on_date(date + 1, DayTime.new(next_day_second % SECONDS_IN_DAY))
      else
        on_date(date, DayTime.new(next_day_second))
      end
    end

    def during_week(week, week_time)
      on_date(week.start_date + week_time.wday, week_time)
    end

  end
end
