module Biz
  class Date

    EPOCH = ::Date.new(2006, 1, 1)

    def self.from_day(day)
      EPOCH + day
    end

    def self.for_dst(date, day_time)
      date +
        (day_time.day_second + Time::SECONDS_IN_HOUR) / Time::SECONDS_IN_DAY
    end

  end
end
