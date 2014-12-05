require 'biz/periods/abstract'
require 'biz/time'
require 'biz/time_segment'
require 'biz/week'

module Biz
  class Periods
    class Before < Abstract

      private

      def weeks
        Week.since_epoch(origin).downto(Week.since_epoch(Time::BIG_BANG))
      end

      def week_periods(week)
        super.reverse
      end

      def boundary
        TimeSegment.before(origin)
      end

      def occurred?(period, time)
        period.start_time <= time.to_i
      end

      def comparison_period(period, time)
        TimeSegment.new(time, period.end_time)
      end

      def duration_period(period, duration)
        TimeSegment.new(period.end_time - duration, period.end_time)
      end

    end
  end
end
