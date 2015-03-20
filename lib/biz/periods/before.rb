module Biz
  class Periods
    class Before < Abstract

      def timeline
        super.backward
      end

      private

      def weeks
        Week.since_epoch(Time.new(time_zone).local(origin)).downto(
          Week.since_epoch(Time::BIG_BANG)
        )
      end

      def relevant?(period)
        origin > period.start_time
      end

      def boundary
        TimeSegment.before(origin)
      end

      def intervals
        super.reverse
      end

    end
  end
end
