module Biz
  class Periods
    class Before < Abstract

      private

      def weeks
        Week.since_epoch(origin).downto(Week.since_epoch(Time::BIG_BANG))
      end

      def work_periods(week)
        super.reverse
      end

      def boundary
        TimeSegment.before(origin)
      end

      def occurred?(period, time)
        period.start_time <= time
      end

      def comparison_period(period, time)
        TimeSegment.new(time, period.end_time)
      end

      def duration_period(period, duration)
        TimeSegment.new(
          period.end_time - duration.in_seconds,
          period.end_time
        )
      end

    end
  end
end
