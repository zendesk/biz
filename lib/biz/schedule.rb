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

    def &(other)
      self.class.new do |config|
        config.hours = Interval.to_hours(
          intervals.flat_map { |interval|
            other
              .intervals
              .map { |other_interval| interval & other_interval }
              .reject(&:empty?)
          }
        )

        config.holidays = [*holidays, *other.holidays].map(&:to_date)

        config.time_zone = time_zone.name
      end
    end

    protected

    attr_reader :configuration

  end
end
