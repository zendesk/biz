module Biz
  module WeekTime
    class Abstract

      include Comparable

      extend Forwardable

      def self.from_time(time)
        new(
          time.wday * Time::MINUTES_IN_DAY +
            time.hour * Time::MINUTES_IN_HOUR +
            time.min
        )
      end

      attr_reader :week_minute

      def initialize(week_minute)
        @week_minute = Integer(week_minute)
      end

      def wday_symbol
        day_of_week.symbol
      end

      delegate wday: :day_of_week

      delegate %i[
        hour
        minute
        second
        day_minute
        day_second
        timestamp
      ] => :day_time

      def <=>(other)
        return unless other.is_a?(WeekTime::Abstract)

        week_minute <=> other.week_minute
      end

    end
  end
end
