module Biz
  module WeekTime
    class End < Abstract

      private

      def day_of_week
        DayOfWeek::DAYS.find { |day| day.contains?(week_minute) }
      end

      def day_time
        DayTime.new(day_of_week.day_minute(week_minute))
      end

      memoize :day_of_week,
              :day_time

    end
  end
end
