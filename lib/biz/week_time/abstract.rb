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

      delegate strftime: :week_time

      delegate %i[
        to_s
        to_i
        to_int
      ] => :week_minute

      def <=>(other)
        return nil unless other.respond_to?(:to_i)

        week_minute <=> other.to_i
      end

      private

      def week_time
        ::Time.new(
          Date::EPOCH.year,
          Date::EPOCH.month,
          Date::EPOCH.mday + wday,
          hour,
          minute
        )
      end

    end
  end
end
