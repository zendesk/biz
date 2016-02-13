module Biz
  module WeekTime
    class Start < Abstract

      def day_time
        @day_time ||= DayTime.from_minute(week_minute % Time::MINUTES_IN_DAY)
      end

      private

      def day_of_week
        @day_of_week ||= begin
          DayOfWeek::DAYS.fetch(
            week_minute / Time::MINUTES_IN_DAY % Time::DAYS_IN_WEEK
          )
        end
      end

    end
  end
end
