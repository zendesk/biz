module Biz
  class Holiday

    attr_reader :date,
                :time_zone

    def initialize(date, time_zone)
      @date      = date
      @time_zone = time_zone
    end

    def contains?(time)
      date == Time.new(time_zone).local(time).to_date
    end

    def to_time_segment
      TimeSegment.new(
        Time.new(time_zone).on_date(date, DayTime.midnight),
        Time.new(time_zone).on_date(date, DayTime.endnight)
      )
    end

    alias to_date date

    def ==(other)
      other.is_a?(self.class) &&
        date == other.date &&
        time_zone == other.time_zone
    end

    alias eql? ==

  end
end
