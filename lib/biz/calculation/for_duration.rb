module Biz
  module Calculation
    class ForDuration

      attr_reader :schedule,
                  :duration

      def initialize(schedule, duration)
        unless duration.positive?
          fail ArgumentError, 'Duration adjustment must be positive.'
        end

        @schedule = schedule
        @duration = duration
      end

      def before(time)
        schedule.periods.before(time)
          .timeline.backward
          .for(duration).to_a
          .last.start_time
      end

      def after(time)
        schedule.periods.after(time)
          .timeline.forward
          .for(duration).to_a
          .last.end_time
      end

    end
  end
end
