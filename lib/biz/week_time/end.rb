module Biz
  module WeekTime
    class End < Abstract

      def day_time
        DayTime.from_minute(day_of_week.day_minute(week_minute))
      end

      private

      def day_of_week
        DayOfWeek::DAYS.find { |day| day.contains?(week_minute) }
      end

      memoize :day_of_week,
              :day_time

    end
  end
end
