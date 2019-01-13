# frozen_string_literal: true

module Biz
  module Periods
    class After < Abstract

      def initialize(schedule, origin)
        @boundary  = TimeSegment.after(origin)
        @intervals = schedule.intervals
        @shifts    = schedule.shifts

        super
      end

      def timeline
        super.forward
      end

      private

      def selector
        :min_by
      end

      def weeks
        Range.new(
          Week.since_epoch(schedule.in_zone.local(origin)),
          Week.since_epoch(Time.heat_death)
        )
      end

    end
  end
end
