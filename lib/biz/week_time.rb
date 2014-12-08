module Biz
  class WeekTime

    include Comparable

    extend Forwardable

    def self.from_time(time)
      new(
        time.wday * Time::MINUTES_IN_DAY +
          time.hour * Time::MINUTES_IN_HOUR +
          time.min
      )
    end

    attr_reader :week_minute

    delegate %i[
      hour
      minute
      day_minute
      timestamp
    ] => :day_time

    delegate strftime: :week_time

    delegate %i[
      to_s
      to_i
      to_int
    ] => :week_minute

    def initialize(week_minute)
      @week_minute = Integer(week_minute)

      @day      = DayOfWeek.from_week_time(self)
      @day_time = DayTime.from_week_time(self)
    end

    def wday
      week_minute / Time::MINUTES_IN_DAY % Time::DAYS_IN_WEEK
    end

    def wday_symbol
      day.symbol
    end

    def week(base_week)
      base_week + relative_week
    end

    def coerce(other)
      [self.class.new(other), self]
    end

    protected

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      week_minute <=> other.to_i
    end

    attr_reader :day,
                :day_time

    private

    def week_time
      ::Time.new(
        Date::EPOCH.year,
        Date::EPOCH.month,
        Date::EPOCH.mday + wday,
        hour,
        minute
      )
    end

    def relative_week
      Week.new(week_minute / Time::MINUTES_IN_WEEK)
    end

  end
end
