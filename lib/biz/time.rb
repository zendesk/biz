module Biz
  class Time

    MINUTE = 60
    HOUR   = 60 * MINUTE
    DAY    = 24 * HOUR
    WEEK   =  7 * DAY

    DAYS_IN_WEEK = 7

    EPOCH = ::Time.utc(1970, 1, 1)

    BIG_BANG   = ::Time.new(-10 ** 100)
    HEAT_DEATH = ::Time.new(10 ** 100)

  end
end
