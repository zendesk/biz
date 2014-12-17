module Biz
  class Timeline
    class After < Abstract

      private

      def occurred?(period, time)
        period.end_time >= time
      end

      def comparison_period(terminus)
        TimeSegment.new(origin, terminus)
      end

      def boundary
        TimeSegment.after(origin)
      end

      def duration_period(period, duration)
        TimeSegment.new(
          period.start_time,
          period.start_time + duration.in_seconds
        )
      end

    end
  end
end
