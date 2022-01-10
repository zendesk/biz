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
            if periods.any?
              periods.next and next if periods.peek.date == shifts.peek.date
            end

            yielder << begin
              sequences
                .filter(&:any?)
                .public_send(selector) { |sequence| sequence.peek.date }
                .next
            end
          end

          if periods.any?
            loop do yielder << periods.next end
          end
        end
      end

    end
  end
end
