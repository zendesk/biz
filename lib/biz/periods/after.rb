module Biz
  class Periods
    class After < Abstract

      private

      def weeks
        Week.since_epoch(origin)..Week.since_epoch(Time::HEAT_DEATH)
      end

      def boundary
        TimeSegment.after(origin)
      end

    end
  end
end
