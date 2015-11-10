module Biz
  module Periods
    class Abstract < Enumerator::Lazy

      extend Forwardable

      def initialize(schedule, origin)
        @schedule = schedule
        @origin   = origin

        super(periods) do |yielder, period| yielder << period end
      end

      delegate time_zone: :schedule

      def timeline
        Timeline::Proxy.new(self)
      end

      protected

      attr_reader :schedule,
                  :origin

      private

      def periods
        weeks
          .lazy
          .flat_map { |week| business_periods(week) }
          .select   { |business_period| relevant?(business_period) }
          .map      { |business_period| business_period & boundary }
          .reject   { |business_period|
            schedule.holidays.any? { |holiday|
              holiday.contains?(business_period.start_time)
            }
          }
      end

      def business_periods(week)
        intervals.lazy.map { |interval| interval.to_time_segment(week) }
      end

      def intervals
        schedule.intervals
      end

    end
  end
end
