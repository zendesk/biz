module Biz
  module Periods
    class Abstract < Enumerator::Lazy

      extend Forwardable

      def initialize(schedule, origin)
        @schedule = schedule
        @origin   = origin

        super(periods) do |yielder, period| yielder << period end
      end

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
          .select   { |period| relevant?(period) }
          .map      { |period| period & boundary }
          .reject   { |period| on_holiday?(period) }
          .reject(&:empty?)
      end

      def business_periods(week)
        intervals.lazy.map { |interval| interval.to_time_segment(week) }
      end

      def on_holiday?(period)
        schedule.holidays.any? { |holiday|
          holiday.contains?(period.start_time)
        }
      end

    end
  end
end
