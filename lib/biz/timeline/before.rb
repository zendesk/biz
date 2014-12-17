module Biz
  class Timeline
    class Before < Abstract

      private

      def occurred?(period, time)
        period.start_time <= time
      end

      def comparison_period(terminus)
        TimeSegment.new(terminus, origin)
      end

      def boundary
        TimeSegment.before(origin)
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
