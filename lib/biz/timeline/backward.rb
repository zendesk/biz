# frozen_string_literal: true

module Biz
  module Timeline
    class Backward < Abstract

      def backward
        self
      end

      private

      def occurred?(period, terminus)
        period.end_time <= terminus
      end

      def overflow?(*)
        false
      end

      def comparison_period(period, terminus)
        TimeSegment.new(terminus, period.end_time)
      end

      def duration_period(period, duration)
        TimeSegment.new(
          period.end_time - duration.in_seconds,
          period.end_time
        )
      end

    end
  end
end
