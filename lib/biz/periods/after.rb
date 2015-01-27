module Biz
  class Periods
    class After < Abstract

      private

      def weeks
        Range.new(
          Week.since_epoch(Time.new(time_zone).local(origin)),
          Week.since_epoch(Time::HEAT_DEATH)
        )
      end

      def boundary
        TimeSegment.after(origin)
      end

    end
  end
end
