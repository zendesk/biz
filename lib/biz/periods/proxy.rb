module Biz
  module Periods
    class Proxy

      def initialize(schedule)
        @schedule = schedule
      end

      def after(origin)
        After.new(schedule, origin)
      end

      def before(origin)
        Before.new(schedule, origin)
      end

      protected

      attr_reader :schedule

    end
  end
end
