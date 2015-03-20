module Biz
  module Calculation
    class Active

      def initialize(schedule, time)
        @schedule = schedule
        @time     = time
      end

      def active?
        schedule.intervals.any? { |interval| interval.contains?(time) } &&
          schedule.holidays.none? { |holiday| holiday.contains?(time) }
      end

      protected

      attr_reader :schedule,
                  :time

    end
  end
end
