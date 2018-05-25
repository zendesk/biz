# frozen_string_literal: true

module Biz
  module Calculation
    class OnHoliday

      def initialize(schedule, time)
        @schedule = schedule
        @time     = time
      end

      def result
        schedule.holidays.any? { |holiday| holiday.contains?(time) }
      end

      private

      attr_reader :schedule,
                  :time

    end
  end
end
