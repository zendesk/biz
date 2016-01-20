module Biz
  class Schedule

    extend Forwardable

    def initialize(&config)
      @configuration = Configuration.new(&config)
    end

    delegate %i[
      intervals
      holidays
      time_zone
      weekdays
    ] => :configuration

    def periods
      Periods::Proxy.new(self)
    end

    def dates
      Dates.new(self)
    end

    alias date dates

    def time(scalar, unit)
      Calculation::ForDuration.with_unit(self, scalar, unit)
    end

    def within(origin, terminus)
      Calculation::DurationWithin.new(self, TimeSegment.new(origin, terminus))
    end

    def in_hours?(time)
      Calculation::Active.new(self, time).result
    end

    def on_holiday?(time)
      Calculation::OnHoliday.new(self, time).result
    end

    alias business_hours? in_hours?

    def in_zone
      Time.new(time_zone)
    end

    protected

    attr_reader :configuration

  end
end
