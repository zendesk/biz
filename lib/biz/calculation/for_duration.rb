module Biz
  module Calculation
    class ForDuration

      attr_reader :active_periods,
                  :duration

      def initialize(active_periods, duration)
        unless duration.positive?
          fail ArgumentError, 'Duration adjustment must be positive.'
        end

        @active_periods = active_periods
        @duration       = duration
      end

      def before(time)
        active_periods.before(time)
          .timeline.backward
          .for(duration).to_a
          .last.start_time
      end

      def after(time)
        active_periods.after(time)
          .timeline.forward
          .for(duration).to_a
          .last.end_time
      end

    end
  end
end
