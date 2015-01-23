module Biz
  class Holiday

    include Equalizer.new(:date, :time_zone)

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

  end
end
