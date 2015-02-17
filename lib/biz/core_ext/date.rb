module Biz
  module CoreExt
    module Date

      def business_day?
        Biz.periods
          .after(Biz::Time.new(Biz.time_zone).on_date(self, DayTime.midnight))
          .timeline.forward
          .until(Biz::Time.new(Biz.time_zone).on_date(self, DayTime.endnight))
          .any?
      end

    end
  end
end
