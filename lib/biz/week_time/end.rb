module Biz
  module WeekTime
    class End < Abstract

      private

      def day_time
        DayTime.new(
          DayOfWeek::DAYS.find { |day_of_week|
            day_of_week.contains?(week_minute)
          }.day_minute(week_minute)
        )
      end

      memoize :day_time

    end
  end
end
