module Biz
  module Calculation
    class Active

      attr_reader :schedule,
                  :time

      def initialize(schedule, time)
        @schedule = schedule
        @time     = time
      end

      def active?
        schedule.intervals.any? { |interval| interval.contain?(time) } &&
          schedule.holidays.none? { |holiday| holiday.contain?(time) }
      end

    end
  end
end
