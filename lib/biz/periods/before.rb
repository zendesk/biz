module Biz
  class Periods
    class Before < Abstract

      private

      def weeks
        Week.since_epoch(origin).downto(Week.since_epoch(Time::BIG_BANG))
      end

      def boundary
        TimeSegment.before(origin)
      end

      def work_periods(week)
        super.reverse
      end

    end
  end
end
