module Biz
  class Schedule

    extend Forwardable

    def initialize(&block)
      @configuration = Configuration.new(&block)
    end

    delegate %i[
      intervals
      holidays
      time_zone
    ] => :configuration

    def periods
      Periods.new(self)
    end

    def time(scalar, unit)
      Calculation::ForDuration.new(
        periods,
        Duration.with_unit(scalar, unit)
      )
    end

    def within(origin, terminus)
      Calculation::DurationWithin.new(
        periods,
        TimeSegment.new(origin, terminus)
      )
    end

    def in_hours?(time)
      Calculation::Active.new(self, time).active?
    end

    alias_method :business_hours?, :in_hours?

    protected

    attr_reader :configuration

  end
end
