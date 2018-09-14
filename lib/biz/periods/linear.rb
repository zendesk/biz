# frozen_string_literal: true

module Biz
  module Periods
    class Linear < SimpleDelegator

      def initialize(periods, shifts, selector)
        @periods   = periods.to_enum
        @shifts    = shifts.to_enum
        @selector  = selector
        @sequences = [@periods, @shifts]

        super(linear_periods)
      end

      private

      attr_reader :periods,
                  :shifts,
                  :selector,
                  :sequences

      def linear_periods
        Enumerator.new do |yielder|
          loop do
            periods.next and next if periods.peek.date == shifts.peek.date

            yielder << begin
              sequences
                .public_send(selector) { |sequence| sequence.peek.date }
                .next
            end
          end

          loop do yielder << periods.next end
        end
      end

    end
  end
end
