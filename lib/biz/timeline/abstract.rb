# frozen_string_literal: true

module Biz
  module Timeline
    class Abstract

      def initialize(periods)
        @periods = periods.lazy
      end

      def until(terminus)
        return enum_for(:until, terminus) unless block_given?

        periods
          .map { |period| period & comparison_period(period, terminus) }
          .each do |period|
            break if occurred?(period, terminus)

            yield period unless period.disjoint?
          end
      end

      def for(duration)
        return enum_for(:for, duration) unless block_given?

        remaining = duration

        periods
          .each do |period|
            if overflow?(period, remaining)
              remaining = Duration.new(0)

              yield period
            else
              scoped_period = period & duration_period(period, remaining)

              remaining -= scoped_period.duration

              yield scoped_period unless scoped_period.disjoint?

              break unless remaining.positive?
            end
          end
      end

      private

      attr_reader :periods

    end
  end
end
