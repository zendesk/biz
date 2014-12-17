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

      private

      def periods
        weeks.lazy.flat_map { |week|
          work_periods(week)
        }.map { |work_period|
          work_period & boundary
        }.flat_map { |work_period|
          holiday_periods.inject([work_period]) { |periods, holiday|
            periods.flat_map { |period| period / holiday }
          }
        }.reject(&:empty?)
      end

      def work_periods(week)
        schedule.intervals.map { |interval| interval.to_time_segment(week) }
      end

      def holiday_periods
        schedule.holidays.map(&:to_time_segment)
      end

    end
  end
end
