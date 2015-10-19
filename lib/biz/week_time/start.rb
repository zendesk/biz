module Biz
  module WeekTime
    class Start < Abstract

      def day_time
        DayTime.from_minute(week_minute % Time::MINUTES_IN_DAY)
      end

      private

      def day_of_week
        DayOfWeek::DAYS.fetch(
          week_minute / Time::MINUTES_IN_DAY % Time::DAYS_IN_WEEK
        )
      end

      memoize :day_of_week,
              :day_time

    end
  end
end
