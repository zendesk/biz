module Biz
  class Timeline
    class Abstract

      attr_reader :periods,
                  :origin

      def initialize(periods, origin)
        @periods = periods
        @origin  = origin
      end

      def until(terminus)
        return enum_for(:until, terminus) unless block_given?

        periods.map { |period|
          period & comparison_period(terminus)
        }.each do |period|
          yield period unless period.empty?

          break if occurred?(period, terminus)
        end
      end

      def for(duration)
        return enum_for(:for, duration) unless block_given?

        remaining = duration

        periods.map { |period|
          period & boundary
        }.map { |period|
          period & duration_period(period, remaining)
        }.each do |period|
          yield period unless period.empty?

          remaining -= period.duration

          break if remaining.zero?
        end
      end

    end
  end
end
