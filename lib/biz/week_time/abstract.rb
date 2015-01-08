module Biz
  module WeekTime
    class Abstract

      include AbstractType
      include Comparable
      include Memoizable

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

      def coerce(other)
        [self.class.new(other), self]
      end

      delegate wday: :day_of_week

      delegate %i[
        hour
        minute
        day_minute
        timestamp
      ] => :day_time

      delegate strftime: :week_time

      delegate %i[
        to_s
        to_i
        to_int
      ] => :week_minute

      protected

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

      abstract_method :day_of_week,
                      :day_time

    end
  end
end
