require 'biz/periods/abstract'
require 'biz/time'
require 'biz/time_segment'
require 'biz/week'

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

      def occurred?(period, time)
        period.end_time >= time.to_i
      end

      def comparison_period(period, time)
        TimeSegment.new(period.start_time, time)
      end

      def duration_period(period, duration)
        TimeSegment.new(period.start_time, period.start_time + duration)
      end

    end
  end
end
