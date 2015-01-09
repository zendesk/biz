module Biz
  module Calculation
    class Active

      attr_reader :active_periods,
                  :time

      def initialize(active_periods, time)
        @active_periods = active_periods
        @time           = time
      end

      def active?
        [
          active_periods.before(time),
          active_periods.after(time)
        ].map(&:first).any? { |active_period| active_period.contain?(time) }
      end

    end
  end
end
