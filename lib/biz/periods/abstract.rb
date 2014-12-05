require 'forwardable'

module Biz
  class Periods
    class Abstract

      include Enumerable

      extend Forwardable

      attr_reader :origin,
                  :work_periods,
                  :holidays

      delegate each: :periods

      def initialize(origin, schedule = {})
        @origin   = origin

        @work_periods = schedule.fetch(:work_periods)
        @holidays     = schedule.fetch(:holidays)
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
          .flat_map { |week| week_periods(week) }
          .map      { |period| period & boundary }
          .flat_map { |period|
            holidays.(period).inject([period]) { |periods, holiday|
              periods.flat_map { |period| period / holiday }
            }
          }.reject(&:empty?)
      end

      def week_periods(week)
        work_periods.(week)
      end

    end
  end
end
