module Biz
  module Calculation
    class ForDuration

      attr_reader :periods,
                  :duration

      def initialize(periods, duration)
        unless duration.positive?
          fail ArgumentError, 'Duration adjustment must be positive.'
        end

        @periods  = periods
        @duration = duration
      end

      def before(time)
        periods.before(time)
          .timeline.backward
          .for(duration).to_a
          .last.start_time
      end

      def after(time)
        periods.after(time)
          .timeline.forward
          .for(duration).to_a
          .last.end_time
      end

    end
  end
end
