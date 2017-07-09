# frozen_string_literal: true

module Biz
  module Calculation
    class Active

      def initialize(schedule, time)
        @schedule = schedule
        @time     = time
      end

      def result
        return in_hours? && active? if schedule.shifts.none?

        schedule.periods.after(time).first.contains?(time)
      end

      private

      attr_reader :schedule,
                  :time

      def in_hours?
        schedule.intervals.any? { |interval| interval.contains?(time) }
      end

      def active?
        schedule.holidays.none? { |holiday| holiday.contains?(time) } &&
          schedule.breaks.none? { |brake| brake.contains?(time) }
      end

    end
  end
end
