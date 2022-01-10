# frozen_string_literal: true

module Biz
  module Periods
    class Abstract < SimpleDelegator

      def initialize(schedule, origin)
        @schedule = schedule
        @origin   = origin

        super(periods)
      end

      def timeline
        Timeline::Proxy.new(self)
      end

      private

      attr_reader :schedule,
                  :origin,
                  :boundary,
                  :intervals,
                  :shifts

      def periods
        Linear.new(week_periods, shifts, selector)
          .lazy
          .map { |period| period & boundary }
          .reject(&:disjoint?)
          .flat_map { |period| active_periods(period) }
          .reject   { |period| on_holiday?(period) }
      end

      def week_periods
        if intervals.empty?
          []
        else
          weeks
            .lazy
            .flat_map { |week|
              intervals.map { |interval| interval.to_time_segment(week) }
            }
        end
      end

      def active_periods(period)
        schedule
          .breaks
          .reduce([period]) { |periods, break_period|
            periods.flat_map { |active_period| active_period / break_period }
          }
      end

      def on_holiday?(period)
        schedule
          .holidays
          .any? { |holiday| holiday.contains?(period.start_time) }
      end

    end
  end
end
