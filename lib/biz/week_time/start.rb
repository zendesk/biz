module Biz
  module WeekTime
    class Start < Abstract

      private

      def day_time
        DayTime.new(week_minute % Time::MINUTES_IN_DAY)
      end

      memoize :day_time

    end
  end
end
