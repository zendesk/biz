# frozen_string_literal: true

module Biz
  module WeekTime
    class Start < Abstract

      def day_time
        @day_time ||= DayTime.from_minute(week_minute % Time.day_minutes)
      end

      private

      def day_of_week
        @day_of_week ||=
          DayOfWeek.all.find { |day_of_week|
            day_of_week.wday?(week_minute / Time.day_minutes % Time.week_days)
          }
      end

    end
  end
end
