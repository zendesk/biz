module Biz
  class Periods
    class Abstract < Enumerator::Lazy

      attr_reader :schedule,
                  :origin

      def initialize(schedule, origin)
        @schedule = schedule
        @origin   = origin

        super(periods) do |yielder, period| yielder << period end
      end

      def timeline
        Timeline.new(self)
      end

      private

      def periods
        weeks.lazy.flat_map { |week|
          business_periods(week)
        }.map { |business_period|
          business_period & boundary
        }.flat_map { |business_period|
          holiday_periods.inject([business_period]) { |periods, holiday|
            periods.flat_map { |period| period / holiday }
          }
        }.reject(&:empty?)
      end

      def business_periods(week)
        schedule.intervals.map { |interval| interval.to_time_segment(week) }
      end

      def holiday_periods
        schedule.holidays.map(&:to_time_segment)
      end

    end
  end
end
