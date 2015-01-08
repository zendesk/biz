module Biz
  class DayOfWeek

    SYMBOLS = [:sun, :mon, :tue, :wed, :thu, :fri, :sat]

    def self.from_time(time)
      DAYS.fetch(time.wday)
    end

    def self.from_symbol(symbol)
      DAYS.fetch(SYMBOLS.index(symbol))
    end

    def self.first
      DAYS.first
    end

    def self.last
      DAYS.last
    end

    class << self

      alias_method :from_date, :from_time

    end

    attr_reader :wday

    def initialize(wday)
      @wday = Integer(wday)
    end

    def contains?(week_time)
      minutes.cover?(week_time)
    end

    def start_minute
      wday * Time::MINUTES_IN_DAY
    end

    def end_minute
      start_minute + Time::MINUTES_IN_DAY
    end

    def minutes
      start_minute..end_minute
    end

    def week_minute(day_minute)
      start_minute + day_minute
    end

    def day_minute(week_minute)
      (week_minute - 1) % Time::MINUTES_IN_DAY + 1
    end

    def symbol
      SYMBOLS.fetch(wday)
    end

    DAYS = [
      SUNDAY    = new(0),
      MONDAY    = new(1),
      TUESDAY   = new(2),
      WEDNESDAY = new(3),
      THURSDAY  = new(4),
      FRIDAY    = new(5),
      SATURDAY  = new(6)
    ]

    WEEKDAYS = [
      MONDAY,
      TUESDAY,
      WEDNESDAY,
      THURSDAY,
      FRIDAY
    ]

  end
end
