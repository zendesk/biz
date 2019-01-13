# frozen_string_literal: true

module Biz
  module Timeline
    class Forward < Abstract

      def forward
        self
      end

      private

      def occurred?(period, terminus)
        period.start_time > terminus
      end

      def overflow?(period, remaining)
        period.duration == remaining
      end

      def comparison_period(period, terminus)
        TimeSegment.new(period.start_time, terminus)
      end

      def duration_period(period, duration)
        TimeSegment.new(
          period.start_time,
          period.start_time + duration.in_seconds
        )
      end

    end
  end
end
