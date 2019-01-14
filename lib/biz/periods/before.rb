# frozen_string_literal: true

module Biz
  module Periods
    class Before < Abstract

      def initialize(schedule, origin)
        @boundary  = TimeSegment.before(origin)
        @intervals = schedule.intervals.reverse
        @shifts    = schedule.shifts.reverse

        super
      end

      def timeline
        super.backward
      end

      private

      def selector
        :max_by
      end

      def weeks
        Week
          .since_epoch(schedule.in_zone.local(origin))
          .downto(Week.since_epoch(Time.big_bang))
      end

      def active_periods(*)
        super.reverse
      end

    end
  end
end
