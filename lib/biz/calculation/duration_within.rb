module Biz
  module Calculation
    class DurationWithin < SimpleDelegator

      def initialize(schedule, calculation_period)
        super(
          schedule.periods.after(calculation_period.start_time)
            .timeline.forward
            .until(calculation_period.end_time).to_a
            .map(&:duration)
            .reduce(Duration.new(0), :+)
        )
      end

    end
  end
end
