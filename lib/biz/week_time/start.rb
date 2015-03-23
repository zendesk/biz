module Biz
  module WeekTime
    class Start < Abstract

      private

      def day_of_week
        DayOfWeek::DAYS.fetch(
          week_minute / Time::MINUTES_IN_DAY % Time::DAYS_IN_WEEK
        )
      end

      def day_time
        DayTime.from_minute(week_minute % Time::MINUTES_IN_DAY)
      end

      memoize :day_of_week,
              :day_time

    end
  end
end
