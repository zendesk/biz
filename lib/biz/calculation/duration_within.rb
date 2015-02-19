module Biz
  module Calculation
    class DurationWithin < SimpleDelegator

      def initialize(periods, calculation_period)
        super(
          periods.after(calculation_period.start_time)
            .timeline.forward
            .until(calculation_period.end_time)
            .map(&:duration)
            .reduce(Duration.new(0), :+)
        )
      end

    end
  end
end
