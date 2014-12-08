module Biz
  class Periods
    class Abstract

      include Enumerable

      extend Forwardable

      attr_reader :schedule,
                  :origin

      delegate each: :periods

      def initialize(schedule, origin)
        @schedule = schedule
        @origin   = origin
      end

      def until(terminus)
        return enum_for(:until, terminus) unless block_given?

        periods.map { |period|
          period & comparison_period(period, terminus)
        }.each do |period|
          yield period unless period.empty?

          break if occurred?(period, terminus)
        end
      end

      def for(duration)
        return enum_for(:for, duration) unless block_given?

        remaining = duration

        periods.map { |period|
          period & duration_period(period, remaining)
        }.each do |period|
          yield period

          remaining -= period.duration

          break if remaining.zero?
        end
      end

      private

      def periods
        weeks
          .lazy
          .flat_map { |week| work_periods(week) }
          .map      { |work_period| work_period & boundary }
          .flat_map { |work_period|
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
